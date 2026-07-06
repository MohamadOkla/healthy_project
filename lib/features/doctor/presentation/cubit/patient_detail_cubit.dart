import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../laboratory/domain/entities/lab_result_entry.dart';
import '../../../laboratory/domain/repositories/laboratory_repository.dart';
import '../../../laboratory/data/repositories/laboratory_repository_impl.dart';
import '../../../medical_records/domain/repositories/medical_records_repository.dart';
import '../../../medical_records/data/repositories/medical_records_repository_impl.dart';
import '../../../notifications/domain/entities/app_notification.dart';
import '../../../notifications/domain/repositories/notifications_repository.dart';
import '../../../notifications/data/repositories/notifications_repository_impl.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';
import '../../../prescriptions/domain/repositories/prescriptions_repository.dart';
import '../../../prescriptions/data/repositories/prescriptions_repository_impl.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../../data/repositories/doctor_repository_impl.dart';
import 'patient_detail_state.dart';

class PatientDetailCubit extends Cubit<PatientDetailState> {
  PatientDetailCubit({
    required String patientId,
    DoctorRepository? doctorRepository,
    MedicalRecordsRepository? medicalRecordsRepository,
    PrescriptionsRepository? prescriptionsRepository,
    LaboratoryRepository? laboratoryRepository,
    NotificationsRepository? notificationsRepository,
  })  : _patientId = patientId,
        _doctorRepository = doctorRepository ?? DoctorRepositoryImpl(),
        _medicalRecordsRepository =
            medicalRecordsRepository ?? MedicalRecordsRepositoryImpl(),
        _prescriptionsRepository =
            prescriptionsRepository ?? PrescriptionsRepositoryImpl(),
        _laboratoryRepository =
            laboratoryRepository ?? LaboratoryRepositoryImpl(),
        _notificationsRepository =
            notificationsRepository ?? NotificationsRepositoryImpl(),
        super(const PatientDetailState()) {
    _load();
  }

  final String _patientId;
  final DoctorRepository _doctorRepository;
  final MedicalRecordsRepository _medicalRecordsRepository;
  final PrescriptionsRepository _prescriptionsRepository;
  final LaboratoryRepository _laboratoryRepository;
  final NotificationsRepository _notificationsRepository;

  static const _doctorName = 'د. سارة منصور';

  void _load() {
    emit(
      state.copyWith(
        patient: _doctorRepository.getPatientById(_patientId),
        medicalRecords:
            _medicalRecordsRepository.getRecordsForPatient(_patientId),
        prescriptions:
            _prescriptionsRepository.getPrescriptionsForPatient(_patientId),
        labResults: _laboratoryRepository.getResultsForPatient(_patientId),
      ),
    );
  }

  void addMedicalRecord({
    required String diagnosis,
    required String symptoms,
    required String doctorNotes,
    List<String> medications = const [],
    List<String> testsRequired = const [],
  }) {
    final patient = state.patient;
    if (patient == null) return;
    _medicalRecordsRepository.addRecord(
      patientId: _patientId,
      doctorName: _doctorName,
      specialty: 'طب عام',
      hospital: 'مشفى دمشق الجامعي',
      diagnosis: diagnosis,
      symptoms: symptoms,
      doctorNotes: doctorNotes,
      medications: medications,
      testsRequired: testsRequired,
    );
    emit(
      state.copyWith(
        medicalRecords:
            _medicalRecordsRepository.getRecordsForPatient(_patientId),
      ),
    );
    _notificationsRepository.addNotification(
      patientId: _patientId,
      type: AppNotificationType.medicalRecord,
      title: 'تمت إضافة سجل طبي جديد',
      description: 'أضاف $_doctorName سجلاً طبياً جديداً: $diagnosis',
      actionRoute: AppRoutes.patientMedicalRecords,
    );
  }

  void addPrescription({
    required String medicineName,
    required String dose,
    required String frequency,
    required String duration,
    required String instructions,
    required String expiryDate,
    required String notes,
    String warnings = '',
  }) {
    _prescriptionsRepository.addPrescription(
      patientId: _patientId,
      doctorName: _doctorName,
      expiryDate: expiryDate,
      medicines: [
        PrescriptionMedicine(
          name: medicineName,
          dose: dose,
          frequency: frequency,
          duration: duration,
          instructions: instructions,
        ),
      ],
      notes: notes,
      warnings: warnings,
    );
    emit(
      state.copyWith(
        prescriptions:
            _prescriptionsRepository.getPrescriptionsForPatient(_patientId),
      ),
    );
    _notificationsRepository.addNotification(
      patientId: _patientId,
      type: AppNotificationType.prescription,
      title: 'تم إصدار وصفة طبية جديدة',
      description: 'أصدر $_doctorName وصفة تحتوي على $medicineName.',
      actionRoute: AppRoutes.patientPrescriptions,
    );
  }

  void addLabResult({
    required String testName,
    required String labName,
    required String summary,
    required String recommendation,
    List<LabResultRow> rows = const [],
    String doctorNotes = '',
  }) {
    _laboratoryRepository.addResult(
      patientId: _patientId,
      testName: testName,
      labName: labName,
      summary: summary,
      rows: rows,
      recommendation: recommendation,
      doctorNotes: doctorNotes,
    );
    emit(
      state.copyWith(
        labResults: _laboratoryRepository.getResultsForPatient(_patientId),
      ),
    );
    _notificationsRepository.addNotification(
      patientId: _patientId,
      type: AppNotificationType.labResult,
      title: 'تمت إضافة نتيجة تحليل جديدة',
      description: 'نتيجة $testName أصبحت متاحة داخل قسم التحاليل.',
      actionRoute: AppRoutes.patientLaboratory,
    );
  }
}
