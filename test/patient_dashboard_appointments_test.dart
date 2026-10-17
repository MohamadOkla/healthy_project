import 'package:flutter_test/flutter_test.dart';
import 'package:healty_app/core/constants/current_patient.dart';
import 'package:healty_app/core/constants/storage_keys.dart';
import 'package:healty_app/core/services/local_storage_service.dart';
import 'package:healty_app/features/appointments/data/local_appointments_repository.dart';
import 'package:healty_app/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:healty_app/features/appointments/presentation/models/appointment_status.dart';
import 'package:healty_app/features/appointments/presentation/models/appointment_ui_model.dart';
import 'package:healty_app/features/patient/presentation/cubit/patient_dashboard_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('a saved and canceled booking refreshes patient and dashboard state',
      () async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.instance.init();
    await LocalStorageService.instance.remove(StorageKeys.localAppointments);

    final repository = LocalAppointmentsRepository();
    final dashboard = PatientDashboardCubit(appointmentsRepository: repository);
    final patientAppointments = AppointmentsCubit(repository: repository);
    final startAt = DateTime.now().add(const Duration(days: 10));
    final start = DateTime(
      startAt.year,
      startAt.month,
      startAt.day,
      9,
    );
    final appointment = AppointmentUiModel(
      id: 'dashboard-booking',
      doctorId: 'd1',
      doctorName: 'د. أحمد خالد',
      specialty: 'قلبية',
      hospital: 'مشفى دمشق الجامعي',
      department: 'قسم القلبية',
      day: 'الأحد',
      date: 'موعد اختباري',
      time: '09:00',
      appointmentNumber: 'LOCAL-TEST',
      status: AppointmentStatus.confirmed,
      notes: '',
      instructions: const [],
      startAt: start,
      patientId: currentPatientId,
      patientName: 'مريض الاختبار',
    );

    expect(await repository.add(appointment), isTrue);
    await Future<void>.delayed(Duration.zero);
    expect(dashboard.state.healthSummary.upcomingAppointments, 1);
    expect(dashboard.state.upcomingAppointment?.appointment.id, appointment.id);
    expect(
      patientAppointments.state.appointments
          .any((item) => item.id == appointment.id),
      isTrue,
    );

    expect(await repository.cancelByDoctor(appointment.id, 'd1'), isTrue);
    await Future<void>.delayed(Duration.zero);
    expect(dashboard.state.healthSummary.upcomingAppointments, 0);
    expect(dashboard.state.upcomingAppointment, isNull);
    expect(
      patientAppointments.state.appointments
          .singleWhere((item) => item.id == appointment.id)
          .status,
      AppointmentStatus.canceledByDoctor,
    );

    await dashboard.close();
    await patientAppointments.close();
  });
}
