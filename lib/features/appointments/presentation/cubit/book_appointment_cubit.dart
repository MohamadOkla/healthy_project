import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local_appointments_repository.dart';
import '../../data/doctor_leave_repository.dart';
import '../data/booking_local_data_source.dart';
import '../models/appointment_ui_model.dart';
import '../models/doctor_ui_model.dart';
import '../models/booking_ids.dart';
import '../models/time_slot_ui_model.dart';
import '../models/appointment_status.dart';
import 'book_appointment_state.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  BookAppointmentCubit({LocalAppointmentsRepository? repository})
      : _repository = repository ?? LocalAppointmentsRepository(),
        super(const BookAppointmentState());

  final LocalAppointmentsRepository _repository;
  final DoctorLeaveRepository _leaveRepository = DoctorLeaveRepository();

  static const specialties = BookingLocalDataSource.specialties;
  static const hospitals = BookingLocalDataSource.hospitals;
  static const visitTypes = BookingLocalDataSource.visitTypes;
  static const doctors = BookingLocalDataSource.doctors;

  bool get canContinueFromBookStep => state.canContinueFromBooking;
  bool get canContinueFromDoctorStep => state.canContinueFromDoctor;
  bool get canConfirmBooking => state.canConfirm;
  bool get canContinueFromDateTime {
    final selectedTime = state.selectedTime;
    return state.canContinueFromDateTime &&
        selectedTime != null &&
        availableSlots.any((slot) =>
            slot.isAvailable && slot.startAt.isAtSameMomentAs(selectedTime));
  }

  void selectSpecialty(SpecialtyId value) {
    if (state.selectedSpecialty == value) return;
    emit(state.copyWith(
        selectedSpecialty: value,
        clearDoctor: true,
        clearDate: true,
        clearTime: true));
  }

  void selectHospital(HospitalId value) {
    if (state.selectedHospital == value) return;
    emit(state.copyWith(
        selectedHospital: value,
        clearDoctor: true,
        clearDate: true,
        clearTime: true));
  }

  void selectVisitType(String value) {
    if (state.selectedVisitType == value) return;
    emit(state.copyWith(selectedVisitType: value));
  }

  void selectDoctor(DoctorUiModel doctor) {
    if (!filteredDoctors.any((item) => item.id == doctor.id)) return;
    if (state.selectedDoctor?.id == doctor.id) return;
    emit(state.copyWith(
        selectedDoctor: doctor, clearDate: true, clearTime: true));
  }

  void selectDate(DateTime date) {
    if (date.isBefore(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
      return;
    }
    if (sameDay(state.selectedDate, date)) return;
    emit(state.copyWith(
        selectedDate: DateTime(date.year, date.month, date.day),
        clearTime: true));
  }

  void selectTime(DateTime time) {
    final date = state.selectedDate;
    final doctor = state.selectedDoctor;
    if (date == null || doctor == null) return;
    final slot = availableSlots
        .any((slot) => slot.startAt.isAtSameMomentAs(time) && slot.isAvailable);
    if (slot) emit(state.copyWith(selectedTime: time));
  }

  void searchDoctors(String query) =>
      emit(state.copyWith(doctorSearchQuery: query));

  List<DoctorUiModel> get filteredDoctors => doctors
      .where((doctor) =>
          (state.selectedHospital == null ||
              doctor.hospitalId == state.selectedHospital) &&
          (state.selectedSpecialty == null ||
              doctor.specialtyId == state.selectedSpecialty))
      .toList(growable: false);

  List<DoctorUiModel> get visibleDoctors {
    final query = state.doctorSearchQuery.trim().toLowerCase();
    return filteredDoctors
        .where((doctor) =>
            query.isEmpty ||
            doctor.name.toLowerCase().contains(query) ||
            doctor.specialty.toLowerCase().contains(query) ||
            doctor.hospital.toLowerCase().contains(query))
        .toList(growable: false);
  }

  List<TimeSlotUiModel> get availableSlots {
    final doctor = state.selectedDoctor;
    final date = state.selectedDate;
    if (doctor == null || date == null) return const [];
    return availableFor(doctor.id, date);
  }

  DateTime? earliestAvailable(DoctorUiModel doctor) {
    for (var offset = 0; offset < 14; offset++) {
      final day = BookingLocalDataSource.dateAtOffset(offset);
      final first = availableFor(doctor.id, day)
          .where((slot) => slot.isAvailable)
          .firstOrNull;
      if (first != null) return first.startAt;
    }
    return null;
  }

  DateTime? nextAvailableDate({int days = 14}) {
    final doctor = state.selectedDoctor;
    if (doctor == null) return null;
    for (var offset = 0; offset < days; offset++) {
      final date = BookingLocalDataSource.dateAtOffset(offset);
      if (availableFor(doctor.id, date).any((slot) => slot.isAvailable)) {
        return date;
      }
    }
    return null;
  }

  void chooseNextAvailableDate() {
    final date = nextAvailableDate();
    if (date != null) selectDate(date);
  }

  void resetBooking() => emit(const BookAppointmentState());

  List<TimeSlotUiModel> availableFor(String doctorId, DateTime date) {
    final booked = _repository
        .load()
        .where((item) => item.doctorId == doctorId && item.startAt != null)
        .map((item) => item.startAt!);
    final slots = BookingLocalDataSource.slotsFor(
      doctorId: doctorId,
      date: date,
      alreadyBooked: booked,
    );
    if (!_leaveRepository.isOnLeave(doctorId, date)) return slots;
    return slots
        .map((slot) => TimeSlotUiModel(
              startAt: slot.startAt,
              isAvailable: false,
            ))
        .toList(growable: false);
  }

  Future<AppointmentUiModel?> confirmBooking() async {
    if (!canConfirmBooking || !_hasValidSelection || !_isCurrentSlotAvailable) {
      return null;
    }
    emit(state.copyWith(isConfirming: true));
    try {
      final doctor = state.selectedDoctor!;
      final start = state.selectedTime!;
      if (!_hasValidSelection || !_isCurrentSlotAvailable) {
        emit(state.copyWith(isConfirming: false, clearTime: true));
        return null;
      }
      final date = DateTime(start.year, start.month, start.day);
      final days = [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد'
      ];
      final appointment = AppointmentUiModel(
        id: 'local-${start.microsecondsSinceEpoch}',
        doctorId: doctor.id,
        doctorName: doctor.name,
        specialty: doctor.specialty,
        hospital: doctor.hospital,
        department: 'قسم ${doctor.specialty}',
        day: days[start.weekday - 1],
        date: '${date.day}/${date.month}/${date.year}',
        time:
            '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
        appointmentNumber: 'LOCAL-${start.microsecondsSinceEpoch % 100000}',
        status: AppointmentStatus.confirmed,
        notes: 'حجز تجريبي محفوظ محلياً؛ لا يمثل تأكيداً من مشفى حقيقي.',
        instructions: const [],
        visitType: state.selectedVisitType!,
        startAt: start,
        durationMinutes: 30,
      );
      await _repository.add(appointment);
      emit(state.copyWith(
          isConfirming: false, confirmedAppointment: appointment));
      return appointment;
    } on Object {
      emit(state.copyWith(isConfirming: false));
      rethrow;
    }
  }

  bool get _hasValidSelection {
    final doctor = state.selectedDoctor;
    final hospital = state.selectedHospital;
    final specialty = state.selectedSpecialty;
    final visitType = state.selectedVisitType;
    final catalogDoctor =
        doctors.where((item) => item.id == doctor?.id).firstOrNull;
    return doctor != null &&
        catalogDoctor != null &&
        identical(doctor, catalogDoctor) &&
        hospital != null &&
        specialty != null &&
        visitType != null &&
        hospitals.contains(hospital) &&
        specialties.contains(specialty) &&
        visitTypes.contains(visitType) &&
        doctor.hospitalId == hospital &&
        doctor.specialtyId == specialty &&
        state.canContinueFromDoctor &&
        state.selectedDate != null &&
        state.selectedTime != null &&
        sameDay(state.selectedDate, state.selectedTime!);
  }

  bool get _isCurrentSlotAvailable {
    final doctor = state.selectedDoctor;
    final date = state.selectedDate;
    final start = state.selectedTime;
    if (doctor == null ||
        date == null ||
        start == null ||
        !start.isAfter(DateTime.now()) ||
        !sameDay(date, start)) {
      return false;
    }
    return availableFor(doctor.id, date).any(
        (slot) => slot.isAvailable && slot.startAt.isAtSameMomentAs(start));
  }

  static bool sameDay(DateTime? left, DateTime right) =>
      left != null &&
      left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}
