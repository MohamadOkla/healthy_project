import 'dart:convert';

import '../../../core/constants/storage_keys.dart';
import '../../../core/services/local_storage_service.dart';
import '../presentation/models/appointment_ui_model.dart';

class LocalAppointmentsRepository {
  LocalAppointmentsRepository({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService.instance;
  final LocalStorageService _storage;

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

  Future<void> add(AppointmentUiModel appointment) async {
    final appointments = load()
        .where((item) => item.id != appointment.id)
        .toList()
      ..add(appointment);
    await _storage.setString(StorageKeys.localAppointments,
        jsonEncode(appointments.map((item) => item.toJson()).toList()));
  }
}
