class TimeSlotUiModel {
  const TimeSlotUiModel({required this.startAt, this.isAvailable = true});

  final DateTime startAt;
  final bool isAvailable;

  String get label =>
      '${startAt.hour.toString().padLeft(2, '0')}:${startAt.minute.toString().padLeft(2, '0')}';
  String get period => startAt.hour < 12 ? 'صباحاً' : 'مساءً';
  String get displayLabel => '$label $period';
}
