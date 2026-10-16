import 'doctor_chat_message.dart';

class DoctorConversation {
  const DoctorConversation({
    required this.id,
    required this.doctorIds,
    required this.messages,
  });

  final String id;
  final List<String> doctorIds;
  final List<DoctorChatMessage> messages;

  DateTime get lastActivity => lastMessage.sentAt;
  DoctorChatMessage get lastMessage => messages.reduce(
        (latest, message) =>
            message.sentAt.isAfter(latest.sentAt) ? message : latest,
      );
  bool includes(String doctorId) => doctorIds.contains(doctorId);

  Map<String, Object?> toJson() => {
        'id': id,
        'doctorIds': doctorIds,
        'messages': messages.map((message) => message.toJson()).toList(),
      };

  factory DoctorConversation.fromJson(Map<String, Object?> json) {
    final doctorIds = (json['doctorIds'] as List<Object?>?)
            ?.whereType<String>()
            .toList(growable: false) ??
        const <String>[];
    final messages = (json['messages'] as List<Object?>?)
            ?.whereType<Map<String, Object?>>()
            .map(DoctorChatMessage.fromJson)
            .toList(growable: false) ??
        const <DoctorChatMessage>[];
    return DoctorConversation(
      id: json['id'] as String? ?? '',
      doctorIds: doctorIds,
      messages: messages,
    );
  }
}
