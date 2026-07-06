class HealthSummaryModel {
  const HealthSummaryModel({
    required this.status,
    required this.lastVisit,
    required this.score,
    required this.upcomingAppointments,
    required this.activePrescriptions,
    required this.newResults,
  });

  final String status;
  final String lastVisit;
  final double score;
  final int upcomingAppointments;
  final int activePrescriptions;
  final int newResults;

  HealthSummaryModel copyWith({
    String? status,
    String? lastVisit,
    double? score,
    int? upcomingAppointments,
    int? activePrescriptions,
    int? newResults,
  }) {
    return HealthSummaryModel(
      status: status ?? this.status,
      lastVisit: lastVisit ?? this.lastVisit,
      score: score ?? this.score,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      activePrescriptions: activePrescriptions ?? this.activePrescriptions,
      newResults: newResults ?? this.newResults,
    );
  }
}
