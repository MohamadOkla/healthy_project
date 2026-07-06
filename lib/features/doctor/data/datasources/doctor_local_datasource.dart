import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/doctor_appointment.dart';
import '../../domain/entities/patient_summary.dart';

class DoctorLocalDataSource {
  DoctorLocalDataSource._({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService.instance;

  static final DoctorLocalDataSource instance = DoctorLocalDataSource._();

  final LocalStorageService _storage;

  /// Patient 'p1' represents the single patient account this demo supports
  /// logging in as. Its identity fields are read live from the same
  /// LocalStorageService keys ProfileCubit persists to, so an edit the
  /// patient makes to their own profile is immediately visible from the
  /// doctor's side too - the same underlying record, two points of view.
  PatientSummary _currentPatient() {
    const defaults = PatientSummary(
      id: 'p1',
      name: 'محمد أحمد',
      age: '32 سنة',
      gender: 'ذكر',
      phone: '+966 55 123 4567',
      lastVisitLabel: 'اليوم',
      primaryDiagnosis: 'متابعة ضغط الدم',
      bloodType: 'O+',
      chronicDiseases: 'لا توجد أمراض مزمنة',
      allergies: 'لا توجد حساسية مسجلة',
    );
    return PatientSummary(
      id: 'p1',
      name: _storage.getString(StorageKeys.profileFullName) ?? defaults.name,
      age: _storage.getString(StorageKeys.profileAge) ?? defaults.age,
      gender: _storage.getString(StorageKeys.profileGender) ?? defaults.gender,
      phone: _storage.getString(StorageKeys.profilePhone) ?? defaults.phone,
      lastVisitLabel: defaults.lastVisitLabel,
      primaryDiagnosis: defaults.primaryDiagnosis,
      bloodType: _storage.getString(StorageKeys.profileBloodType) ??
          defaults.bloodType,
      chronicDiseases:
          _storage.getString(StorageKeys.profileChronicDiseases) ??
              defaults.chronicDiseases,
      allergies: _storage.getString(StorageKeys.profileAllergies) ??
          defaults.allergies,
    );
  }

  static const List<PatientSummary> _otherPatients = [
    PatientSummary(
      id: 'p2',
      name: 'يوسف علي',
      age: '46 سنة',
      gender: 'ذكر',
      phone: '+963 933 222 333',
      lastVisitLabel: 'أمس',
      primaryDiagnosis: 'متابعة خطة علاج السكري',
      bloodType: 'O+',
      chronicDiseases: 'سكري نوع 2',
      allergies: 'حساسية من البنسلين',
    ),
    PatientSummary(
      id: 'p3',
      name: 'نورا فيصل',
      age: '29 سنة',
      gender: 'أنثى',
      phone: '+963 955 333 444',
      lastVisitLabel: 'منذ يومين',
      primaryDiagnosis: 'مراجعة ما بعد جراحة',
      bloodType: 'B+',
      chronicDiseases: 'لا توجد أمراض مزمنة',
      allergies: 'لا توجد حساسية مسجلة',
    ),
    PatientSummary(
      id: 'p4',
      name: 'كريم حسن',
      age: '52 سنة',
      gender: 'ذكر',
      phone: '+963 966 444 555',
      lastVisitLabel: 'منذ 5 أيام',
      primaryDiagnosis: 'متابعة الربو',
      bloodType: 'AB+',
      chronicDiseases: 'ربو شعبي',
      allergies: 'حساسية من الغبار',
    ),
    PatientSummary(
      id: 'p5',
      name: 'هبة سليم',
      age: '61 سنة',
      gender: 'أنثى',
      phone: '+963 944 555 666',
      lastVisitLabel: 'منذ أسبوع',
      primaryDiagnosis: 'هشاشة عظام',
      bloodType: 'O-',
      chronicDiseases: 'هشاشة عظام',
      allergies: 'لا توجد حساسية مسجلة',
    ),
    PatientSummary(
      id: 'p6',
      name: 'طارق نعمان',
      age: '38 سنة',
      gender: 'ذكر',
      phone: '+963 933 666 777',
      lastVisitLabel: 'اليوم',
      primaryDiagnosis: 'فحص دوري',
      bloodType: 'A-',
      chronicDiseases: 'لا توجد أمراض مزمنة',
      allergies: 'لا توجد حساسية مسجلة',
    ),
  ];

  static const List<DoctorAppointment> _todayAppointments = [
    DoctorAppointment(
      id: 'da1',
      patientId: 'p1',
      patientName: 'محمد أحمد',
      time: '09:30 صباحًا',
      visitType: 'مراجعة دورية',
      status: DoctorAppointmentStatus.confirmed,
    ),
    DoctorAppointment(
      id: 'da2',
      patientId: 'p2',
      patientName: 'يوسف علي',
      time: '10:15 صباحًا',
      visitType: 'مراجعة نتائج مخبرية',
      status: DoctorAppointmentStatus.waiting,
    ),
    DoctorAppointment(
      id: 'da3',
      patientId: 'p6',
      patientName: 'طارق نعمان',
      time: '11:00 صباحًا',
      visitType: 'استشارة',
      status: DoctorAppointmentStatus.urgent,
    ),
    DoctorAppointment(
      id: 'da4',
      patientId: 'p4',
      patientName: 'كريم حسن',
      time: '11:45 صباحًا',
      visitType: 'متابعة الربو',
      status: DoctorAppointmentStatus.confirmed,
    ),
  ];

  List<PatientSummary> getPatients() =>
      List.unmodifiable([_currentPatient(), ..._otherPatients]);

  PatientSummary? getPatientById(String patientId) {
    if (patientId == 'p1') return _currentPatient();
    for (final patient in _otherPatients) {
      if (patient.id == patientId) return patient;
    }
    return null;
  }

  List<DoctorAppointment> getTodayAppointments() {
    final currentName = _currentPatient().name;
    return List.unmodifiable(
      _todayAppointments.map((appointment) {
        if (appointment.patientId != 'p1') return appointment;
        return DoctorAppointment(
          id: appointment.id,
          patientId: appointment.patientId,
          patientName: currentName,
          time: appointment.time,
          visitType: appointment.visitType,
          status: appointment.status,
        );
      }),
    );
  }
}
