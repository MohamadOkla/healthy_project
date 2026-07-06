import 'package:equatable/equatable.dart';

import '../../../laboratory/domain/entities/lab_result_entry.dart';
import '../../../medical_records/domain/entities/medical_record_entry.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';
import '../../domain/entities/patient_summary.dart';

class PatientDetailState extends Equatable {
  const PatientDetailState({
    this.patient,
    this.medicalRecords = const [],
    this.prescriptions = const [],
    this.labResults = const [],
  });

  final PatientSummary? patient;
  final List<MedicalRecordEntry> medicalRecords;
  final List<PrescriptionEntry> prescriptions;
  final List<LabResultEntry> labResults;

  PatientDetailState copyWith({
    PatientSummary? patient,
    List<MedicalRecordEntry>? medicalRecords,
    List<PrescriptionEntry>? prescriptions,
    List<LabResultEntry>? labResults,
  }) {
    return PatientDetailState(
      patient: patient ?? this.patient,
      medicalRecords: medicalRecords ?? this.medicalRecords,
      prescriptions: prescriptions ?? this.prescriptions,
      labResults: labResults ?? this.labResults,
    );
  }

  @override
  List<Object?> get props => [
        patient,
        medicalRecords,
        prescriptions,
        labResults,
      ];
}
