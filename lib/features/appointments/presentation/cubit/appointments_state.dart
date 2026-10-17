import 'package:equatable/equatable.dart';

import '../models/appointment_status.dart';
import '../models/appointment_ui_model.dart';

class AppointmentsState extends Equatable {
  const AppointmentsState({
    required this.appointments,
    this.selectedStatus = AppointmentStatus.confirmed,
    this.searchQuery = '',
    this.specialtyFilter,
    this.dateFilter,
    this.isLoading = false,
  });

  final List<AppointmentUiModel> appointments;
  final AppointmentStatus selectedStatus;
  final String searchQuery;
  final String? specialtyFilter;
  final String? dateFilter;
  final bool isLoading;

  List<AppointmentUiModel> get visibleAppointments {
    return appointments.where((appointment) {
      final query = searchQuery.trim().toLowerCase();
      final matchesStatus = selectedStatus == AppointmentStatus.canceled
          ? appointment.status == AppointmentStatus.canceled ||
              appointment.status == AppointmentStatus.canceledByDoctor
          : appointment.status == selectedStatus;
      final matchesSearch = query.isEmpty ||
          appointment.doctorName.toLowerCase().contains(query) ||
          appointment.specialty.toLowerCase().contains(query) ||
          appointment.hospital.toLowerCase().contains(query);
      final matchesSpecialty =
          specialtyFilter == null || appointment.specialty == specialtyFilter;
      final matchesDate = dateFilter == null || appointment.date == dateFilter;
      return matchesStatus && matchesSearch && matchesSpecialty && matchesDate;
    }).toList(growable: false);
  }

  int get upcomingCount => appointments
      .where((appointment) =>
          appointment.status == AppointmentStatus.confirmed &&
          appointment.startAt != null &&
          appointment.startAt!.isAfter(DateTime.now()))
      .length;

  int get previousCount => appointments
      .where((appointment) => appointment.status == AppointmentStatus.completed)
      .length;

  int get canceledCount => appointments
      .where((appointment) =>
          appointment.status == AppointmentStatus.canceled ||
          appointment.status == AppointmentStatus.canceledByDoctor)
      .length;

  AppointmentUiModel get selectedAppointment => appointments.first;

  AppointmentsState copyWith({
    List<AppointmentUiModel>? appointments,
    AppointmentStatus? selectedStatus,
    String? searchQuery,
    String? specialtyFilter,
    String? dateFilter,
    bool? isLoading,
    bool clearSpecialtyFilter = false,
    bool clearDateFilter = false,
  }) {
    return AppointmentsState(
      appointments: appointments ?? this.appointments,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      specialtyFilter:
          clearSpecialtyFilter ? null : specialtyFilter ?? this.specialtyFilter,
      dateFilter: clearDateFilter ? null : dateFilter ?? this.dateFilter,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        appointments,
        selectedStatus,
        searchQuery,
        specialtyFilter,
        dateFilter,
        isLoading,
      ];
}
