import 'package:equatable/equatable.dart';
import '../models/appointment_ui_model.dart';
import '../models/doctor_ui_model.dart';
import '../models/booking_ids.dart';

class BookAppointmentState extends Equatable {
  const BookAppointmentState(
      {this.selectedSpecialty,
      this.selectedHospital,
      this.selectedVisitType,
      this.selectedDoctor,
      this.selectedDate,
      this.selectedTime,
      this.doctorSearchQuery = '',
      this.isConfirming = false,
      this.confirmedAppointment});

  final SpecialtyId? selectedSpecialty;
  final HospitalId? selectedHospital;
  final String? selectedVisitType;
  final DoctorUiModel? selectedDoctor;
  final DateTime? selectedDate;
  final DateTime? selectedTime;
  final String doctorSearchQuery;
  final bool isConfirming;
  final AppointmentUiModel? confirmedAppointment;

  bool get canContinueFromBooking =>
      selectedSpecialty != null &&
      selectedHospital != null &&
      selectedVisitType != null;
  bool get canContinueFromDoctor =>
      selectedDoctor != null &&
      selectedDoctor!.specialtyId == selectedSpecialty &&
      selectedDoctor!.hospitalId == selectedHospital;
  bool get canContinueFromDateTime =>
      canContinueFromDoctor &&
      selectedDate != null &&
      selectedTime != null &&
      selectedTime!.isAfter(DateTime.now());
  bool get canConfirm =>
      canContinueFromDateTime && !isConfirming && confirmedAppointment == null;

  BookAppointmentState copyWith(
          {SpecialtyId? selectedSpecialty,
          HospitalId? selectedHospital,
          String? selectedVisitType,
          DoctorUiModel? selectedDoctor,
          DateTime? selectedDate,
          DateTime? selectedTime,
          String? doctorSearchQuery,
          bool? isConfirming,
          AppointmentUiModel? confirmedAppointment,
          bool clearConfirmedAppointment = false,
          bool clearSpecialty = false,
          bool clearHospital = false,
          bool clearVisitType = false,
          bool clearDoctor = false,
          bool clearDate = false,
          bool clearTime = false}) =>
      BookAppointmentState(
        selectedSpecialty:
            clearSpecialty ? null : selectedSpecialty ?? this.selectedSpecialty,
        selectedHospital:
            clearHospital ? null : selectedHospital ?? this.selectedHospital,
        selectedVisitType:
            clearVisitType ? null : selectedVisitType ?? this.selectedVisitType,
        selectedDoctor:
            clearDoctor ? null : selectedDoctor ?? this.selectedDoctor,
        selectedDate: clearDate ? null : selectedDate ?? this.selectedDate,
        selectedTime: clearTime ? null : selectedTime ?? this.selectedTime,
        doctorSearchQuery: doctorSearchQuery ?? this.doctorSearchQuery,
        isConfirming: isConfirming ?? this.isConfirming,
        confirmedAppointment: clearConfirmedAppointment
            ? null
            : confirmedAppointment ?? this.confirmedAppointment,
      );

  @override
  List<Object?> get props => [
        selectedSpecialty,
        selectedHospital,
        selectedVisitType,
        selectedDoctor,
        selectedDate,
        selectedTime,
        doctorSearchQuery,
        isConfirming,
        confirmedAppointment
      ];
}
