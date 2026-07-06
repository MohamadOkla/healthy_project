/// A patient as seen from a doctor's point of view: enough summary
/// information to list, search, and open a patient's file.
class PatientSummary {
  const PatientSummary({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.lastVisitLabel,
    required this.primaryDiagnosis,
    required this.bloodType,
    required this.chronicDiseases,
    required this.allergies,
  });

  final String id;
  final String name;
  final String age;
  final String gender;
  final String phone;
  final String lastVisitLabel;
  final String primaryDiagnosis;
  final String bloodType;
  final String chronicDiseases;
  final String allergies;

  /// Two-letter initials derived from the name, e.g. "لينا محمود" -> "لم".
  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    final first = parts.first.substring(0, 1);
    if (parts.length == 1) return first;
    final second = parts[1].substring(0, 1);
    return '$first$second';
  }
}
