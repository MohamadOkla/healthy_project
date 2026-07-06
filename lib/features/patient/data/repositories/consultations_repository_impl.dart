import '../../domain/entities/consultation.dart';
import '../../domain/repositories/consultations_repository.dart';
import '../datasources/consultations_local_datasource.dart';

class ConsultationsRepositoryImpl implements ConsultationsRepository {
  ConsultationsRepositoryImpl({ConsultationsLocalDataSource? dataSource})
      : _dataSource = dataSource ?? ConsultationsLocalDataSource.instance;

  final ConsultationsLocalDataSource _dataSource;

  @override
  List<Consultation> getConsultationsForPatient(String patientId) {
    return _dataSource.getConsultationsForPatient(patientId);
  }

  @override
  List<Consultation> getPendingConsultations() {
    return _dataSource.getPendingConsultations();
  }

  @override
  Consultation addConsultation({
    required String patientId,
    required String doctorName,
    required String subject,
    required String patientQuestion,
  }) {
    return _dataSource.addConsultation(
      patientId: patientId,
      doctorName: doctorName,
      subject: subject,
      patientQuestion: patientQuestion,
    );
  }
}
