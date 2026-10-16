import '../models/medical_timeline_event.dart';

enum TimelineTypeFilter { all, visits, prescriptions, labResults, attachments }

class TimelineDoctorFilter {
  const TimelineDoctorFilter({required this.key, required this.name, this.id});

  final String key;
  final String name;
  final String? id;

  @override
  bool operator ==(Object other) =>
      other is TimelineDoctorFilter && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

class MedicalTimelineState {
  const MedicalTimelineState({
    this.events = const [],
    this.typeFilter = TimelineTypeFilter.all,
    this.startDate,
    this.endDate,
    this.doctorFilter,
    this.isLoading = false,
    this.error,
    this.hasLoaded = false,
  });

  final List<MedicalTimelineEvent> events;
  final TimelineTypeFilter typeFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final TimelineDoctorFilter? doctorFilter;
  final bool isLoading;
  final Object? error;
  final bool hasLoaded;

  MedicalTimelineState copyWith({
    List<MedicalTimelineEvent>? events,
    TimelineTypeFilter? typeFilter,
    DateTime? startDate,
    DateTime? endDate,
    TimelineDoctorFilter? doctorFilter,
    bool? isLoading,
    Object? error,
    bool? hasLoaded,
    bool clearTypeFilter = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearDoctorFilter = false,
    bool clearError = false,
  }) =>
      MedicalTimelineState(
        events: events ?? this.events,
        typeFilter: clearTypeFilter
            ? TimelineTypeFilter.all
            : typeFilter ?? this.typeFilter,
        startDate: clearStartDate ? null : startDate ?? this.startDate,
        endDate: clearEndDate ? null : endDate ?? this.endDate,
        doctorFilter:
            clearDoctorFilter ? null : doctorFilter ?? this.doctorFilter,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
        hasLoaded: hasLoaded ?? this.hasLoaded,
      );
}
