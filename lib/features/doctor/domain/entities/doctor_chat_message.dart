class DoctorChatMessage {
  const DoctorChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.sentAt,
  });

  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;

  Map<String, Object?> toJson() => {
        'id': id,
        'senderId': senderId,
        'text': text,
        'sentAt': sentAt.toIso8601String(),
      };

  factory DoctorChatMessage.fromJson(Map<String, Object?> json) =>
      DoctorChatMessage(
        id: json['id'] as String? ?? '',
        senderId: json['senderId'] as String? ?? '',
        text: json['text'] as String? ?? '',
        sentAt: DateTime.parse(json['sentAt'] as String),
      );
}
