import 'appointment_status.dart';

class AppointmentUiModel {
  const AppointmentUiModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.department,
    required this.day,
    required this.date,
    required this.time,
    required this.appointmentNumber,
    required this.status,
    required this.notes,
    required this.instructions,
    this.doctorId = '',
    this.visitType = 'كشف جديد',
    this.startAt,
    this.durationMinutes = 30,
    this.patientId = 'p1',
    this.patientName = 'محمد أحمد',
  });

  final String id;
  final String doctorName;
  final String specialty;
  final String hospital;
  final String department;
  final String day;
  final String date;
  final String time;
  final String appointmentNumber;
  final AppointmentStatus status;
  final String notes;
  final List<String> instructions;
  final String doctorId;
  final String visitType;
  final DateTime? startAt;
  final int durationMinutes;
  final String patientId;
  final String patientName;

  Map<String, Object?> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'specialty': specialty,
        'hospital': hospital,
        'department': department,
        'day': day,
        'date': date,
        'time': time,
        'appointmentNumber': appointmentNumber,
        'status': status.name,
        'notes': notes,
        'instructions': instructions,
        'visitType': visitType,
        'startAt': startAt?.toIso8601String(),
        'durationMinutes': durationMinutes,
        'patientId': patientId,
        'patientName': patientName,
      };

  factory AppointmentUiModel.fromJson(Map<String, Object?> json) {
    final rawStatus = json['status'] as String? ?? 'confirmed';
    return AppointmentUiModel(
      id: json['id'] as String? ?? '',
      doctorId: json['doctorId'] as String? ?? '',
      doctorName: json['doctorName'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      hospital: json['hospital'] as String? ?? '',
      department: json['department'] as String? ?? '',
      day: json['day'] as String? ?? '',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      appointmentNumber: json['appointmentNumber'] as String? ?? '',
      status: AppointmentStatus.values.firstWhere(
          (value) => value.name == rawStatus,
          orElse: () => AppointmentStatus.confirmed),
      notes: json['notes'] as String? ?? '',
      instructions: (json['instructions'] as List<Object?>? ?? const [])
          .whereType<String>()
          .toList(),
      visitType: json['visitType'] as String? ?? 'كشف جديد',
      startAt: DateTime.tryParse(json['startAt'] as String? ?? ''),
      durationMinutes: json['durationMinutes'] as int? ?? 30,
      patientId: json['patientId'] as String? ?? 'p1',
      patientName: json['patientName'] as String? ?? 'محمد أحمد',
    );
  }
}
