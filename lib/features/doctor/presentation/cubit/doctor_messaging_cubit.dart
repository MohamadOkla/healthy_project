import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../appointments/presentation/models/doctor_ui_model.dart';
import '../../data/repositories/doctor_messaging_repository.dart';
import '../../domain/entities/doctor_chat_message.dart';
import '../../domain/entities/doctor_conversation.dart';

class DoctorMessagingState extends Equatable {
  const DoctorMessagingState({
    this.isLoading = false,
    this.isSending = false,
    this.conversations = const [],
    this.messages = const [],
    this.activePeerId,
    this.error,
    this.sendError = false,
  });

  final bool isLoading;
  final bool isSending;
  final List<DoctorConversation> conversations;
  final List<DoctorChatMessage> messages;
  final String? activePeerId;
  final String? error;
  final bool sendError;

  DoctorMessagingState copyWith({
    bool? isLoading,
    bool? isSending,
    List<DoctorConversation>? conversations,
    List<DoctorChatMessage>? messages,
    String? activePeerId,
    bool clearActivePeer = false,
    String? error,
    bool clearError = false,
    bool? sendError,
  }) =>
      DoctorMessagingState(
        isLoading: isLoading ?? this.isLoading,
        isSending: isSending ?? this.isSending,
        conversations: conversations ?? this.conversations,
        messages: messages ?? this.messages,
        activePeerId:
            clearActivePeer ? null : activePeerId ?? this.activePeerId,
        error: clearError ? null : error ?? this.error,
        sendError: sendError ?? this.sendError,
      );

  @override
  List<Object?> get props => [
        isLoading,
        isSending,
        conversations,
        messages,
        activePeerId,
        error,
        sendError,
      ];
}

class DoctorMessagingCubit extends Cubit<DoctorMessagingState> {
  DoctorMessagingCubit({DoctorMessagingRepository? repository})
      : _repository = repository ?? DoctorMessagingRepository(),
        super(const DoctorMessagingState());

  final DoctorMessagingRepository _repository;

  String get currentDoctorId => _repository.currentDoctorId;
  bool get currentUserIsDoctor => _repository.currentUserIsDoctor;
  DoctorUiModel? doctorById(String id) => _repository.doctorById(id);
  List<DoctorUiModel> otherDoctors({String? query}) =>
      _repository.otherDoctors(query: query);

  Future<bool> selectLocalDemoDoctor(String doctorId) async {
    final selected = await _repository.selectLocalDemoDoctor(doctorId);
    if (selected) await loadInbox();
    return selected;
  }

  Future<void> loadInbox() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      if (!currentUserIsDoctor) {
        emit(state.copyWith(
          isLoading: false,
          error: 'المراسلة متاحة لحسابات الأطباء فقط.',
        ));
        return;
      }
      final conversations =
          _repository.conversationsFor(_repository.currentDoctorId);
      emit(state.copyWith(isLoading: false, conversations: conversations));
    } on Object {
      emit(state.copyWith(isLoading: false, error: 'تعذر تحميل المحادثات.'));
    }
  }

  Future<void> openConversation(String peerId) async {
    emit(state.copyWith(
      isLoading: true,
      activePeerId: peerId,
      messages: const [],
      clearError: true,
      sendError: false,
    ));
    try {
      if (!currentUserIsDoctor ||
          peerId == currentDoctorId ||
          _repository.doctorById(peerId) == null) {
        emit(state.copyWith(isLoading: false, error: 'تعذر فتح هذه المحادثة.'));
        return;
      }
      final messages = _repository.messagesFor(currentDoctorId, peerId);
      emit(state.copyWith(isLoading: false, messages: messages));
    } on Object {
      emit(state.copyWith(isLoading: false, error: 'تعذر تحميل الرسائل.'));
    }
  }

  Future<bool> send(String text) async {
    final peerId = state.activePeerId;
    if (peerId == null || text.trim().isEmpty || state.isSending) return false;
    emit(state.copyWith(isSending: true, sendError: false, clearError: true));
    final result = await _repository.sendMessage(
      doctorId: currentDoctorId,
      peerId: peerId,
      text: text,
    );
    if (isClosed) return false;
    if (result == DoctorMessageSendResult.sent) {
      emit(state.copyWith(
        isSending: false,
        messages: _repository.messagesFor(currentDoctorId, peerId),
        conversations: _repository.conversationsFor(currentDoctorId),
        sendError: false,
      ));
      return true;
    }
    emit(state.copyWith(
      isSending: false,
      sendError: true,
      error: result == DoctorMessageSendResult.unauthorized
          ? 'لا تملك صلاحية الوصول إلى هذه المحادثة.'
          : 'تعذر إرسال الرسالة. احتفظنا بالنص، ويمكنك إعادة المحاولة.',
    ));
    return false;
  }

  void clearSendError() {
    if (state.sendError || state.error != null) {
      emit(state.copyWith(sendError: false, clearError: true));
    }
  }
}
