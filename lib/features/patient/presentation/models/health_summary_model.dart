class HealthSummaryModel {
  const HealthSummaryModel({
    required this.lastVisit,
    required this.upcomingAppointments,
    required this.activePrescriptions,
    required this.newResults,
  });

  final String lastVisit;
  final int upcomingAppointments;
  final int activePrescriptions;
  final int newResults;

  HealthSummaryModel copyWith({
    String? lastVisit,
    int? upcomingAppointments,
    int? activePrescriptions,
    int? newResults,
  }) {
    return HealthSummaryModel(
      lastVisit: lastVisit ?? this.lastVisit,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      activePrescriptions: activePrescriptions ?? this.activePrescriptions,
      newResults: newResults ?? this.newResults,
    );
  }
}
