import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healty_app/core/constants/storage_keys.dart';
import 'package:healty_app/core/services/local_storage_service.dart';
import 'package:healty_app/features/appointments/data/doctor_leave_repository.dart';
import 'package:healty_app/features/appointments/presentation/cubit/book_appointment_cubit.dart';
import 'package:healty_app/features/appointments/presentation/data/booking_local_data_source.dart';
import 'package:healty_app/features/appointments/presentation/models/booking_ids.dart';
import 'package:healty_app/features/hospital_admin/data/repositories/hospital_admin_repository_impl.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.instance.init();
    await LocalStorageService.instance.clear();
    await LocalStorageService.instance
        .setString(StorageKeys.currentUserRole, 'hospitalAdmin');
  });

  test('validates leave ranges and restricts managers to their hospital',
      () async {
    final repository = DoctorLeaveRepository();
    final day = DateTime(2026, 10, 20);

    expect(
      await repository.save(
        doctorId: 'd1',
        startsOn: day,
        endsOn: day.subtract(const Duration(days: 1)),
        reason: 'إجازة سنوية',
      ),
      DoctorLeaveSaveResult.invalidRange,
    );
    expect(
      await repository.save(
        doctorId: 'd2',
        startsOn: day,
        endsOn: day.add(const Duration(days: 1)),
        reason: 'إجازة سنوية',
      ),
      DoctorLeaveSaveResult.doctorNotManaged,
    );
    expect(HospitalAdminRepositoryImpl().getDoctorById('d2'), isNull);

    await LocalStorageService.instance
        .setString(StorageKeys.currentUserRole, 'patient');
    expect(
      await repository.save(
        doctorId: 'd1',
        startsOn: day,
        endsOn: day,
        reason: 'إجازة سنوية',
      ),
      DoctorLeaveSaveResult.notAuthorized,
    );
  });

  test('requires and trims a leave reason while reading older saved entries',
      () async {
    final repository = DoctorLeaveRepository();
    final day = DateTime(2026, 10, 20);
    expect(
      await repository.save(
        doctorId: 'd1',
        startsOn: day,
        endsOn: day,
        reason: '   ',
      ),
      DoctorLeaveSaveResult.missingReason,
    );

    await LocalStorageService.instance.setString(
      StorageKeys.localDoctorLeaves,
      '[{"id":"old","doctorId":"d1","hospitalId":"damascusUniversity",'
      '"startsOn":"2026-10-20T00:00:00.000",'
      '"endsOn":"2026-10-20T00:00:00.000"}]',
    );
    expect(repository.forDoctor('d1').single.reason, isEmpty);
  });

  test('persists, updates, and cancels inclusive doctor leave periods',
      () async {
    final repository = DoctorLeaveRepository();
    final start = DateTime(2026, 10, 20);
    final end = DateTime(2026, 10, 25);
    expect(
      await repository.save(
        doctorId: 'd1',
        startsOn: start,
        endsOn: end,
        reason: 'إجازة سنوية',
      ),
      DoctorLeaveSaveResult.saved,
    );

    final savedLeave = repository.forDoctor('d1').single;
    expect(savedLeave.hospitalId, 'damascusUniversity');
    expect(savedLeave.reason, 'إجازة سنوية');
    expect(repository.isOnLeave('d1', start), isTrue);
    expect(repository.isOnLeave('d1', end), isTrue);
    expect(repository.isOnLeave('d1', start.subtract(const Duration(days: 1))),
        isFalse);
    expect(
      await repository.save(
        doctorId: 'd1',
        startsOn: end,
        endsOn: end.add(const Duration(days: 1)),
        reason: 'مهمة خاصة',
      ),
      DoctorLeaveSaveResult.overlaps,
    );

    expect(
      await repository.save(
        doctorId: 'd1',
        startsOn: start,
        endsOn: end.add(const Duration(days: 1)),
        reason: 'ظرف عائلي',
        leaveId: savedLeave.id,
      ),
      DoctorLeaveSaveResult.saved,
    );
    expect(repository.forDoctor('d1').single.endsOn,
        end.add(const Duration(days: 1)));
    expect(repository.forDoctor('d1').single.reason, 'ظرف عائلي');
    expect(await repository.cancel(savedLeave.id), isTrue);
    expect(repository.forDoctor('d1'), isEmpty);
  });

  test('booking slots are unavailable on every day of a doctor leave',
      () async {
    final repository = DoctorLeaveRepository();
    final leaveDay = BookingLocalDataSource.dateAtOffset(1);
    final doctor = BookAppointmentCubit.doctors.first;
    final cubit = BookAppointmentCubit();
    cubit.selectHospital(HospitalId.damascusUniversity);
    cubit.selectSpecialty(SpecialtyId.cardiology);
    cubit.selectVisitType('كشف جديد');
    cubit.selectDoctor(doctor);
    cubit.selectDate(leaveDay);
    cubit.selectTime(DateTime(leaveDay.year, leaveDay.month, leaveDay.day, 9));
    expect(cubit.state.selectedTime, isNotNull);

    await repository.save(
      doctorId: 'd1',
      startsOn: leaveDay,
      endsOn: leaveDay,
      reason: 'إجازة سنوية',
    );

    expect(cubit.availableFor('d1', leaveDay), isNotEmpty);
    expect(
        cubit.availableFor('d1', leaveDay).every((slot) => !slot.isAvailable),
        isTrue);
    expect(await cubit.confirmBooking(), isNull);
    cubit.close();
  });
}
