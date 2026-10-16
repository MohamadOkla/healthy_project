import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../appointments/presentation/data/booking_local_data_source.dart';
import '../../../appointments/presentation/models/doctor_ui_model.dart';
import '../../domain/entities/doctor_chat_message.dart';
import '../../domain/entities/doctor_conversation.dart';

enum DoctorMessageSendResult { sent, unauthorized, invalidRecipient, failed }

/// Device-local doctor-to-doctor conversations. This repository deliberately
/// keeps the participant check at every read and write boundary.
class DoctorMessagingRepository {
  DoctorMessagingRepository({
    LocalStorageService? storage,
    String? currentDoctorId,
  })  : _storage = storage ?? LocalStorageService.instance,
        _providedCurrentDoctorId = currentDoctorId;

  final LocalStorageService _storage;
  final String? _providedCurrentDoctorId;

  List<DoctorUiModel> get doctors => BookingLocalDataSource.doctors;
  bool get currentUserIsDoctor =>
      _storage.getString(StorageKeys.currentUserRole) == 'doctor';

  String get currentDoctorId {
    final supplied = _providedCurrentDoctorId;
    if (supplied != null && doctors.any((doctor) => doctor.id == supplied)) {
      return supplied;
    }
    final savedId = _storage.getString(StorageKeys.currentDoctorAccountId);
    if (savedId != null && doctors.any((doctor) => doctor.id == savedId)) {
      return savedId;
    }
    final email = _storage.getString(StorageKeys.profileEmail)?.toLowerCase();
    final byEmail =
        doctors.where((doctor) => doctor.email.toLowerCase() == email);
    if (byEmail.isNotEmpty) return byEmail.first.id;
    final name = _storage.getString(StorageKeys.profileFullName);
    final byName = doctors.where((doctor) => doctor.name == name);
    // The current demo doctor dashboard has no account ID. Use a stable local
    // identity until its authentication flow supplies the saved account ID.
    return byName.firstOrNull?.id ?? 'd1';
  }

  DoctorUiModel? doctorById(String id) =>
      doctors.where((doctor) => doctor.id == id).firstOrNull;

  Future<bool> selectLocalDemoDoctor(String doctorId) async {
    if (_storage.getString(StorageKeys.currentUserRole) != 'doctor' ||
        doctorById(doctorId) == null) {
      return false;
    }
    await _storage.setString(StorageKeys.currentDoctorAccountId, doctorId);
    return true;
  }

  List<DoctorUiModel> otherDoctors({String? query}) {
    final search = query?.trim().toLowerCase() ?? '';
    return doctors.where((doctor) {
      if (doctor.id == currentDoctorId) return false;
      return search.isEmpty ||
          doctor.name.toLowerCase().contains(search) ||
          doctor.specialty.toLowerCase().contains(search) ||
          doctor.hospital.toLowerCase().contains(search);
    }).toList(growable: false);
  }

  List<DoctorConversation> conversationsFor(String doctorId) {
    if (!_isCurrentDoctor(doctorId)) return const [];
    return _load()
        .where((conversation) =>
            conversation.includes(doctorId) &&
            conversation.messages.isNotEmpty &&
            conversation.doctorIds.length == 2 &&
            conversation.doctorIds.every((id) => doctorById(id) != null))
        .toList()
      ..sort((left, right) => right.lastActivity.compareTo(left.lastActivity));
  }

  DoctorConversation? conversationWith(String doctorId, String peerId) {
    if (!_isCurrentDoctor(doctorId) || !_isValidPeer(doctorId, peerId)) {
      return null;
    }
    final id = conversationId(doctorId, peerId);
    final conversation = _load().where((item) => item.id == id).firstOrNull;
    if (conversation == null ||
        conversation.doctorIds.length != 2 ||
        !conversation.includes(doctorId) ||
        !conversation.includes(peerId)) {
      return null;
    }
    return conversation;
  }

  List<DoctorChatMessage> messagesFor(String doctorId, String peerId) {
    final conversation = conversationWith(doctorId, peerId);
    if (conversation == null || !conversation.includes(doctorId)) {
      return const [];
    }
    return conversation.messages.toList(growable: false)
      ..sort((left, right) => left.sentAt.compareTo(right.sentAt));
  }

  Future<DoctorMessageSendResult> sendMessage({
    required String doctorId,
    required String peerId,
    required String text,
    DateTime? sentAt,
  }) async {
    if (!_isCurrentDoctor(doctorId)) {
      return DoctorMessageSendResult.unauthorized;
    }
    if (!_isValidPeer(doctorId, peerId)) {
      return DoctorMessageSendResult.invalidRecipient;
    }
    final normalized = text.trim();
    if (normalized.isEmpty) return DoctorMessageSendResult.failed;

    try {
      final conversations = _load().toList();
      final id = conversationId(doctorId, peerId);
      final index = conversations.indexWhere((item) => item.id == id);
      final oldConversation = index < 0 ? null : conversations[index];
      // A stable, sorted pair ID makes creating the first message idempotent.
      final timestamp = sentAt ?? DateTime.now();
      final message = DoctorChatMessage(
        id: '$id-${timestamp.microsecondsSinceEpoch}',
        senderId: doctorId,
        text: normalized,
        sentAt: timestamp,
      );
      final updated = DoctorConversation(
        id: id,
        doctorIds: _sortedPair(doctorId, peerId),
        messages: [...?oldConversation?.messages, message]
          ..sort((left, right) => left.sentAt.compareTo(right.sentAt)),
      );
      if (index < 0) {
        conversations.add(updated);
      } else {
        if (!oldConversation!.includes(doctorId) ||
            !oldConversation.includes(peerId)) {
          return DoctorMessageSendResult.unauthorized;
        }
        conversations[index] = updated;
      }
      await _storage.setString(
        StorageKeys.localDoctorConversations,
        jsonEncode(conversations.map((item) => item.toJson()).toList()),
      );
      return DoctorMessageSendResult.sent;
    } on Object {
      return DoctorMessageSendResult.failed;
    }
  }

  bool _isCurrentDoctor(String doctorId) =>
      _storage.getString(StorageKeys.currentUserRole) == 'doctor' &&
      doctorId == currentDoctorId &&
      doctorById(doctorId) != null;

  bool _isValidPeer(String doctorId, String peerId) =>
      doctorId != peerId && doctorById(peerId) != null;

  List<DoctorConversation> _load() {
    final raw = _storage.getString(StorageKeys.localDoctorConversations);
    if (raw == null) return const [];
    try {
      final decoded = jsonDecode(raw) as List<Object?>;
      return decoded
          .whereType<Map<String, Object?>>()
          .map(DoctorConversation.fromJson)
          .where((item) => item.id.isNotEmpty)
          .toList(growable: false);
    } on Object {
      return const [];
    }
  }

  static List<String> _sortedPair(String first, String second) =>
      [first, second]..sort();

  static String conversationId(String first, String second) =>
      _sortedPair(first, second).join('--');
}
