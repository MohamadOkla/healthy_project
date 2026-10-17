import '../../../appointments/presentation/models/appointment_ui_model.dart';

class AppointmentModel {
  const AppointmentModel({required this.appointment});

  final AppointmentUiModel appointment;

  String get doctorName => appointment.doctorName;
  String get specialty => appointment.specialty;
  String get hospital => appointment.hospital;
  String get day => appointment.day;
  String get date => appointment.date;
  String get time => appointment.time;
}
