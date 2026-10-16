import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healty_app/core/services/local_storage_service.dart';
import 'package:healty_app/features/appointments/data/local_appointments_repository.dart';
import 'package:healty_app/features/appointments/presentation/cubit/book_appointment_cubit.dart';
import 'package:healty_app/features/appointments/presentation/cubit/book_appointment_state.dart';
import 'package:healty_app/features/appointments/presentation/data/booking_local_data_source.dart';
import 'package:healty_app/features/appointments/presentation/models/appointment_status.dart';
import 'package:healty_app/features/appointments/presentation/models/appointment_ui_model.dart';
import 'package:healty_app/features/appointments/presentation/models/booking_ids.dart';

void main() {
  group('booking filters and dependent selections', () {
    test(
        'filters doctors by hospital and specialty together, then searches within them',
        () {
      final cubit = BookAppointmentCubit();
      cubit.selectHospital(HospitalId.damascusUniversity);
      cubit.selectSpecialty(SpecialtyId.cardiology);
      expect(cubit.filteredDoctors.map((doctor) => doctor.id), ['d1', 'd6']);
      cubit.searchDoctors('رانيا');
      expect(cubit.visibleDoctors, isEmpty);
      cubit.searchDoctors('أحمد');
      expect(cubit.visibleDoctors.map((doctor) => doctor.id), ['d1']);
      cubit.searchDoctors('دمشق');
      expect(cubit.visibleDoctors.map((doctor) => doctor.id), ['d1', 'd6']);
      cubit.searchDoctors('قلبية');
      expect(cubit.visibleDoctors.map((doctor) => doctor.id), ['d1', 'd6']);
      cubit.close();
    });

    test(
        'same filter keeps valid choices while changed filter clears descendants',
        () {
      final cubit = BookAppointmentCubit();
      final doctor = BookAppointmentCubit.doctors.first;
      final date = BookingLocalDataSource.dateAtOffset(1);
      final time = DateTime(date.year, date.month, date.day, 9);
      cubit.selectHospital(doctor.hospitalId);
      cubit.selectSpecialty(doctor.specialtyId);
      cubit.selectVisitType('كشف جديد');
      cubit.selectDoctor(doctor);
      cubit.selectDate(date);
      cubit.selectTime(time);

      cubit.selectHospital(doctor.hospitalId);
      cubit.selectSpecialty(doctor.specialtyId);
      expect(cubit.state.selectedDoctor, doctor);
      expect(cubit.state.selectedDate, date);
      expect(cubit.state.selectedTime, time);

      cubit.selectHospital(HospitalId.alMouwasat);
      expect(cubit.state.selectedDoctor, isNull);
      expect(cubit.state.selectedDate, isNull);
      expect(cubit.state.selectedTime, isNull);
      cubit.selectSpecialty(SpecialtyId.cardiology);
      expect(cubit.state.selectedHospital, HospitalId.alMouwasat);
      cubit.close();
    });

    test('changing doctor clears date and time; changing date clears only time',
        () {
      final cubit = BookAppointmentCubit();
      final doctor = BookAppointmentCubit.doctors.first;
      final otherDoctor = BookAppointmentCubit.doctors[5];
      final date = BookingLocalDataSource.dateAtOffset(1);
      cubit.selectHospital(doctor.hospitalId);
      cubit.selectSpecialty(doctor.specialtyId);
      cubit.selectVisitType('كشف جديد');
      cubit.selectDoctor(doctor);
      cubit.selectDate(date);
      cubit.selectTime(DateTime(date.year, date.month, date.day, 9));

      cubit.selectDate(date);
      expect(cubit.state.selectedTime, isNotNull);
      cubit.selectDate(date.add(const Duration(days: 1)));
      expect(cubit.state.selectedDate, date.add(const Duration(days: 1)));
      expect(cubit.state.selectedTime, isNull);

      cubit.selectDate(date);
      cubit.selectTime(DateTime(date.year, date.month, date.day, 9));
      cubit.selectDoctor(otherDoctor);
      expect(cubit.state.selectedDate, isNull);
      expect(cubit.state.selectedTime, isNull);
      cubit.close();
    });

    test('changing specialty clears the selected doctor, date, and time', () {
      final cubit = BookAppointmentCubit();
      final doctor = BookAppointmentCubit.doctors.first;
      final date = BookingLocalDataSource.dateAtOffset(1);
      cubit.selectHospital(doctor.hospitalId);
      cubit.selectSpecialty(doctor.specialtyId);
      cubit.selectVisitType('كشف جديد');
      cubit.selectDoctor(doctor);
      cubit.selectDate(date);
      cubit.selectTime(DateTime(date.year, date.month, date.day, 9));

      cubit.selectSpecialty(SpecialtyId.dermatology);
      expect(cubit.state.selectedDoctor, isNull);
      expect(cubit.state.selectedDate, isNull);
      expect(cubit.state.selectedTime, isNull);
      cubit.close();
    });
  });

  test('copyWith can explicitly clear nullable booking filters', () {
    final state = BookAppointmentState(
      selectedHospital: HospitalId.damascusUniversity,
      selectedSpecialty: SpecialtyId.cardiology,
      selectedVisitType: 'كشف جديد',
    );
    final cleared = state.copyWith(
      clearHospital: true,
      clearSpecialty: true,
      clearVisitType: true,
    );
    expect(cleared.selectedHospital, isNull);
    expect(cleared.selectedSpecialty, isNull);
    expect(cleared.selectedVisitType, isNull);
  });

  test('rejects a doctor outside selected hospital and specialty', () {
    final state = BookAppointmentState(
      selectedHospital: HospitalId.damascusUniversity,
      selectedSpecialty: SpecialtyId.cardiology,
      selectedVisitType: 'كشف جديد',
      selectedDoctor: BookAppointmentCubit.doctors[1],
    );
    expect(state.canContinueFromDoctor, isFalse);
  });

  group('local slot availability', () {
    final now = DateTime(2026, 10, 16, 8);

    test(
        'does not expose past dates or times and excludes a locally booked slot',
        () {
      final yesterday = DateTime(2026, 10, 15);
      expect(
          BookingLocalDataSource.slotsFor(
              doctorId: 'd1', date: yesterday, now: now),
          isEmpty);
      final today = DateTime(2026, 10, 16);
      final laterToday = BookingLocalDataSource.slotsFor(
        doctorId: 'd1',
        date: today,
        now: DateTime(2026, 10, 16, 10),
      );
      expect(laterToday.first.isAvailable, isFalse);
      expect(laterToday.last.isAvailable, isTrue);
      final tomorrow = DateTime(2026, 10, 17);
      final slots = BookingLocalDataSource.slotsFor(
        doctorId: 'd1',
        date: tomorrow,
        now: now,
        alreadyBooked: [DateTime(2026, 10, 17, 9)],
      );
      expect(slots.first.isAvailable, isFalse);
      expect(slots.last.isAvailable, isTrue);
    });

    test(
        'calculates the earliest available appointment and handles an empty range',
        () {
      expect(BookingLocalDataSource.earliestAvailable('d1', now: now),
          DateTime(2026, 10, 16, 9));
      expect(BookingLocalDataSource.earliestAvailable('d3', now: now), isNull);
    });

    test('rejects selecting an unavailable slot and duplicate booked slot', () {
      final cubit = BookAppointmentCubit();
      final doctor = BookAppointmentCubit.doctors.first;
      final tomorrow = BookingLocalDataSource.dateAtOffset(1);
      cubit.selectHospital(doctor.hospitalId);
      cubit.selectSpecialty(doctor.specialtyId);
      cubit.selectVisitType('كشف جديد');
      cubit.selectDoctor(doctor);
      cubit.selectDate(tomorrow);
      final unavailable =
          DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 8);
      cubit.selectTime(unavailable);
      expect(cubit.state.selectedTime, isNull);
      cubit.close();
    });
  });

  test(
      'persists a confirmed local appointment through the existing storage service',
      () async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.instance.init();
    final repository = LocalAppointmentsRepository();
    final start = DateTime(2026, 11, 1, 9);
    final appointment = AppointmentUiModel(
      id: 'local-test',
      doctorId: 'd1',
      doctorName: 'د. أحمد خالد',
      specialty: 'قلبية',
      hospital: 'مشفى دمشق الجامعي',
      department: 'قسم قلبية',
      day: 'الأحد',
      date: '1/11/2026',
      time: '09:00',
      appointmentNumber: 'LOCAL-1',
      status: AppointmentStatus.confirmed,
      notes: 'حجز تجريبي محلي',
      instructions: const [],
      startAt: start,
    );

    await repository.add(appointment);
    final saved = repository.load().single;
    expect(saved.id, appointment.id);
    expect(saved.startAt, start);
    expect(saved.doctorId, 'd1');
  });
}
