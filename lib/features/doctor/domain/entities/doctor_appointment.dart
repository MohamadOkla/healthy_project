enum DoctorAppointmentStatus { confirmed, waiting, urgent, completed }

/// An appointment as seen on a doctor's schedule.
class DoctorAppointment {
  const DoctorAppointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.time,
    required this.visitType,
    required this.status,
  });

  final String id;
  final String patientId;
  final String patientName;
  final String time;
  final String visitType;
  final DoctorAppointmentStatus status;
}
