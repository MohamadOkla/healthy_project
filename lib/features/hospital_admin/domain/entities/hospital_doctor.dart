enum HospitalDoctorStatus { active, onLeave }

/// A doctor as seen from the hospital administrator's roster.
class HospitalDoctor {
  const HospitalDoctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phone,
    required this.email,
    required this.patientsCount,
    required this.todayAppointmentsCount,
    required this.status,
  });

  final String id;
  final String name;
  final String specialty;
  final String phone;
  final String email;
  final int patientsCount;
  final int todayAppointmentsCount;
  final HospitalDoctorStatus status;

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    final first = parts.first.substring(0, 1);
    if (parts.length == 1) return first;
    return '$first${parts[1].substring(0, 1)}';
  }

  HospitalDoctor copyWith({HospitalDoctorStatus? status}) {
    return HospitalDoctor(
      id: id,
      name: name,
      specialty: specialty,
      phone: phone,
      email: email,
      patientsCount: patientsCount,
      todayAppointmentsCount: todayAppointmentsCount,
      status: status ?? this.status,
    );
  }
}
