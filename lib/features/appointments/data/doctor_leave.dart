class DoctorLeave {
  const DoctorLeave({
    required this.id,
    required this.doctorId,
    required this.hospitalId,
    required this.startsOn,
    required this.endsOn,
    this.reason = '',
  });

  final String id;
  final String doctorId;
  final String hospitalId;
  final DateTime startsOn;
  final DateTime endsOn;
  final String reason;

  bool includes(DateTime date) {
    final day = dateOnly(date);
    return !day.isBefore(startsOn) && !day.isAfter(endsOn);
  }

  String get formattedRange =>
      '${formatDate(startsOn)} إلى ${formatDate(endsOn)}';

  Map<String, Object?> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'hospitalId': hospitalId,
        'startsOn': startsOn.toIso8601String(),
        'endsOn': endsOn.toIso8601String(),
        'reason': reason,
      };

  factory DoctorLeave.fromJson(Map<String, Object?> json) => DoctorLeave(
        id: json['id'] as String? ?? '',
        doctorId: json['doctorId'] as String? ?? '',
        hospitalId: json['hospitalId'] as String? ?? '',
        startsOn: dateOnly(DateTime.parse(json['startsOn'] as String)),
        endsOn: dateOnly(DateTime.parse(json['endsOn'] as String)),
        reason: json['reason'] as String? ?? '',
      );

  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static String formatDate(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}
