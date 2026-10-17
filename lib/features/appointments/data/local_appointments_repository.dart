import 'dart:convert';
import 'dart:async';

import '../../../core/constants/storage_keys.dart';
import '../../../core/services/local_storage_service.dart';
import '../../doctor/data/repositories/doctor_messaging_repository.dart';
import '../presentation/models/appointment_ui_model.dart';
import '../presentation/models/appointment_status.dart';

class LocalAppointmentsRepository {
  LocalAppointmentsRepository({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService.instance;
  final LocalStorageService _storage;
  static Future<void> _writeQueue = Future<void>.value();
  static final StreamController<List<AppointmentUiModel>> _changes =
      StreamController<List<AppointmentUiModel>>.broadcast();

  Stream<List<AppointmentUiModel>> get changes => _changes.stream;

  List<AppointmentUiModel> load() {
    final raw = _storage.getString(StorageKeys.localAppointments);
    if (raw == null) return const [];
    try {
      final decoded = jsonDecode(raw) as List<Object?>;
      return decoded
          .whereType<Map<String, Object?>>()
          .map(AppointmentUiModel.fromJson)
          .toList(growable: false);
    } on Object {
      return const [];
    }
  }

  /// Saves the appointment atomically with respect to other local writes.
  /// Returns false if another active appointment already owns the same slot.
  Future<bool> add(AppointmentUiModel appointment) {
    if (appointment.startAt == null) return Future.value(false);
    return _exclusive(() async {
      final appointments = load();
      final duplicate = appointments.any((item) =>
          item.id != appointment.id &&
          item.doctorId == appointment.doctorId &&
          appointment.startAt != null &&
          item.startAt?.isAtSameMomentAs(appointment.startAt!) == true &&
          item.status == AppointmentStatus.confirmed);
      if (duplicate) return false;
      final updated = appointments
          .where((item) => item.id != appointment.id)
          .toList()
        ..add(appointment);
      await _save(updated);
      return true;
    });
  }

  Future<bool> cancelByDoctor(String appointmentId, String doctorId) =>
      _exclusive(() async {
        if (doctorId != DoctorMessagingRepository().currentDoctorId) {
          return false;
        }
        final appointments = load();
        final index = appointments.indexWhere((item) =>
            item.id == appointmentId &&
            item.doctorId == doctorId &&
            item.status == AppointmentStatus.confirmed &&
            item.startAt != null &&
            item.startAt!.isAfter(DateTime.now()));
        if (index < 0) return false;
        final appointment = appointments[index];
        appointments[index] = AppointmentUiModel(
          id: appointment.id,
          doctorId: appointment.doctorId,
          doctorName: appointment.doctorName,
          specialty: appointment.specialty,
          hospital: appointment.hospital,
          department: appointment.department,
          day: appointment.day,
          date: appointment.date,
          time: appointment.time,
          appointmentNumber: appointment.appointmentNumber,
          status: AppointmentStatus.canceledByDoctor,
          notes: 'ألغى الطبيب هذا الموعد.',
          instructions: appointment.instructions,
          visitType: appointment.visitType,
          startAt: appointment.startAt,
          durationMinutes: appointment.durationMinutes,
          patientId: appointment.patientId,
          patientName: appointment.patientName,
        );
        await _save(appointments);
        return true;
      });

  Future<void> _save(List<AppointmentUiModel> appointments) async {
    final serialized =
        jsonEncode(appointments.map((item) => item.toJson()).toList());
    await _storage.setString(StorageKeys.localAppointments, serialized);
    if (_storage.getString(StorageKeys.localAppointments) != serialized) {
      throw StateError('Failed to persist local appointments.');
    }
    _changes.add(List.unmodifiable(appointments));
  }

  Future<T> _exclusive<T>(Future<T> Function() action) {
    final result = _writeQueue.then((_) => action());
    _writeQueue =
        result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return result;
  }
}
