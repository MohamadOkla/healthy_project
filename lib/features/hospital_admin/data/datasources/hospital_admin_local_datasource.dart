import '../../domain/entities/hospital_doctor.dart';

class HospitalAdminLocalDataSource {
  HospitalAdminLocalDataSource._();

  static final HospitalAdminLocalDataSource instance =
      HospitalAdminLocalDataSource._();

  final List<HospitalDoctor> _doctors = [
    const HospitalDoctor(
      id: 'doc1',
      name: 'د. سارة منصور',
      specialty: 'طب عام',
      phone: '+963 944 010 101',
      email: 's.mansour@hospital.example',
      patientsCount: 6,
      todayAppointmentsCount: 4,
      status: HospitalDoctorStatus.active,
    ),
    const HospitalDoctor(
      id: 'doc2',
      name: 'د. عمر الحلبي',
      specialty: 'قلبية',
      phone: '+963 933 020 202',
      email: 'o.halabi@hospital.example',
      patientsCount: 34,
      todayAppointmentsCount: 7,
      status: HospitalDoctorStatus.active,
    ),
    const HospitalDoctor(
      id: 'doc3',
      name: 'د. رهف قاسم',
      specialty: 'جلدية',
      phone: '+963 955 030 303',
      email: 'r.kassem@hospital.example',
      patientsCount: 21,
      todayAppointmentsCount: 5,
      status: HospitalDoctorStatus.active,
    ),
    const HospitalDoctor(
      id: 'doc4',
      name: 'د. ياسر نجم',
      specialty: 'عظمية',
      phone: '+963 966 040 404',
      email: 'y.najm@hospital.example',
      patientsCount: 18,
      todayAppointmentsCount: 0,
      status: HospitalDoctorStatus.onLeave,
    ),
    const HospitalDoctor(
      id: 'doc5',
      name: 'د. لينا شهاب',
      specialty: 'أطفال',
      phone: '+963 944 050 505',
      email: 'l.shehab@hospital.example',
      patientsCount: 42,
      todayAppointmentsCount: 9,
      status: HospitalDoctorStatus.active,
    ),
    const HospitalDoctor(
      id: 'doc6',
      name: 'د. كريم عيسى',
      specialty: 'باطنية',
      phone: '+963 933 060 606',
      email: 'k.eissa@hospital.example',
      patientsCount: 27,
      todayAppointmentsCount: 6,
      status: HospitalDoctorStatus.active,
    ),
  ];

  List<HospitalDoctor> getDoctors() => List.unmodifiable(_doctors);

  HospitalDoctor? getDoctorById(String doctorId) {
    for (final doctor in _doctors) {
      if (doctor.id == doctorId) return doctor;
    }
    return null;
  }

  void setDoctorStatus(String doctorId, HospitalDoctorStatus status) {
    final index = _doctors.indexWhere((doctor) => doctor.id == doctorId);
    if (index == -1) return;
    _doctors[index] = _doctors[index].copyWith(status: status);
  }
}
