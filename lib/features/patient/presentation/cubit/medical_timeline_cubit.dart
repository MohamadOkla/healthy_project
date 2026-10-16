import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/current_patient.dart';
import '../../data/repositories/medical_timeline_repository.dart';
import '../models/medical_timeline_event.dart';
import 'medical_timeline_state.dart';

class MedicalTimelineCubit extends Cubit<MedicalTimelineState> {
  MedicalTimelineCubit({
    String patientId = currentPatientId,
    MedicalTimelineRepository? repository,
  })  : _patientId = patientId,
        _repository = repository ?? MedicalTimelineRepository(),
        super(const MedicalTimelineState(isLoading: true)) {
    load();
  }

  final String _patientId;
  final MedicalTimelineRepository _repository;

  List<TimelineDoctorFilter> get availableDoctors {
    final byKey = <String, TimelineDoctorFilter>{};
    for (final event in state.events) {
      final name = event.doctorName?.trim();
      if (name == null || name.isEmpty) continue;
      final id = event.doctorId?.trim();
      final key = id == null || id.isEmpty ? 'name:$name' : 'id:$id';
      byKey.putIfAbsent(
          key, () => TimelineDoctorFilter(key: key, name: name, id: id));
    }
    final doctors = byKey.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return List.unmodifiable(doctors);
  }

  List<MedicalTimelineEvent> get visibleEvents => state.events.where((event) {
        final matchesType = switch (state.typeFilter) {
          TimelineTypeFilter.all => true,
          TimelineTypeFilter.visits =>
            event.type == MedicalTimelineEventType.visit,
          TimelineTypeFilter.prescriptions =>
            event.type == MedicalTimelineEventType.prescription,
          TimelineTypeFilter.labResults =>
            event.type == MedicalTimelineEventType.labResult,
          TimelineTypeFilter.attachments => event.attachments.isNotEmpty,
        };
        if (!matchesType) return false;

        final date = event.occurredAt;
        final start = state.startDate;
        final end = state.endDate;
        if ((start != null || end != null) && date == null) return false;
        if (date != null && start != null && _day(date).isBefore(start)) {
          return false;
        }
        if (date != null && end != null && _day(date).isAfter(end)) {
          return false;
        }

        final selectedDoctor = state.doctorFilter;
        if (selectedDoctor != null) {
          final doctorId = event.doctorId?.trim();
          if (selectedDoctor.id != null && selectedDoctor.id!.isNotEmpty) {
            if (doctorId != selectedDoctor.id) return false;
          } else if (event.doctorName?.trim() != selectedDoctor.name) {
            return false;
          }
        }
        return true;
      }).toList(growable: false);

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final events = _repository.getEventsForPatient(_patientId);
      emit(state.copyWith(
          events: events, isLoading: false, hasLoaded: true, clearError: true));
    } on Object catch (error) {
      emit(state.copyWith(isLoading: false, error: error, hasLoaded: true));
    }
  }

  Future<void> refresh() => load();

  void setTypeFilter(TimelineTypeFilter value) =>
      emit(state.copyWith(typeFilter: value));

  void setDoctorFilter(TimelineDoctorFilter? value) {
    if (value == null) {
      emit(state.copyWith(clearDoctorFilter: true));
    } else {
      emit(state.copyWith(doctorFilter: value));
    }
  }

  bool setStartDate(DateTime? value) {
    final date = value == null ? null : _day(value);
    if (date != null && state.endDate != null && date.isAfter(state.endDate!)) {
      return false;
    }
    emit(date == null
        ? state.copyWith(clearStartDate: true)
        : state.copyWith(startDate: date));
    return true;
  }

  bool setEndDate(DateTime? value) {
    final date = value == null ? null : _day(value);
    if (date != null &&
        state.startDate != null &&
        date.isBefore(state.startDate!)) {
      return false;
    }
    emit(date == null
        ? state.copyWith(clearEndDate: true)
        : state.copyWith(endDate: date));
    return true;
  }

  void clearTypeFilter() => emit(state.copyWith(clearTypeFilter: true));
  void clearStartDate() => emit(state.copyWith(clearStartDate: true));
  void clearEndDate() => emit(state.copyWith(clearEndDate: true));
  void clearDoctorFilter() => emit(state.copyWith(clearDoctorFilter: true));

  void clearFilters() => emit(state.copyWith(
        clearTypeFilter: true,
        clearStartDate: true,
        clearEndDate: true,
        clearDoctorFilter: true,
      ));

  static DateTime _day(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
