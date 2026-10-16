import 'dart:convert';

import '../../../core/constants/storage_keys.dart';
import '../../../core/services/local_storage_service.dart';
import '../../hospital_admin/data/repositories/hospital_admin_repository_impl.dart';
import '../../hospital_admin/domain/repositories/hospital_admin_repository.dart';
import 'doctor_leave.dart';

enum DoctorLeaveSaveResult {
  saved,
  invalidRange,
  missingReason,
  notAuthorized,
  doctorNotManaged,
  overlaps,
}

/// Local shared leave storage used by both the hospital and patient flows.
/// On this demo build, the data is shared only by accounts on the same device.
class DoctorLeaveRepository {
  DoctorLeaveRepository({
    LocalStorageService? storage,
    HospitalAdminRepository? hospitals,
  })  : _storage = storage ?? LocalStorageService.instance,
        _hospitals = hospitals ?? HospitalAdminRepositoryImpl();

  final LocalStorageService _storage;
  final HospitalAdminRepository _hospitals;

  String get managerHospitalId => _hospitals.currentHospitalId;
  bool get _isHospitalAdmin =>
      _storage.getString(StorageKeys.currentUserRole) == 'hospitalAdmin';

  List<DoctorLeave> load() {
    final raw = _storage.getString(StorageKeys.localDoctorLeaves);
    if (raw == null) return const [];
    try {
      final json = jsonDecode(raw) as List<Object?>;
      return json
          .whereType<Map<String, Object?>>()
          .map(DoctorLeave.fromJson)
          .toList(growable: false);
    } on Object {
      return const [];
    }
  }

  List<DoctorLeave> forDoctor(String doctorId) => load()
      .where((leave) =>
          leave.doctorId == doctorId && leave.hospitalId == managerHospitalId)
      .toList()
    ..sort((left, right) => left.startsOn.compareTo(right.startsOn));

  List<DoctorLeave> upcomingForDoctor(String doctorId, {DateTime? now}) {
    final today = DoctorLeave.dateOnly(now ?? DateTime.now());
    return load()
        .where((leave) =>
            leave.doctorId == doctorId && !leave.endsOn.isBefore(today))
        .toList()
      ..sort((left, right) => left.startsOn.compareTo(right.startsOn));
  }

  bool isOnLeave(String doctorId, DateTime date) => load().any((leave) =>
      leave.doctorId == doctorId &&
      leave.hospitalId == managerHospitalId &&
      leave.includes(date));

  Future<DoctorLeaveSaveResult> save({
    required String doctorId,
    required DateTime startsOn,
    required DateTime endsOn,
    required String reason,
    String? leaveId,
  }) async {
    if (!_isHospitalAdmin) return DoctorLeaveSaveResult.notAuthorized;
    final normalizedReason = reason.trim();
    if (normalizedReason.isEmpty) return DoctorLeaveSaveResult.missingReason;
    final start = DoctorLeave.dateOnly(startsOn);
    final end = DoctorLeave.dateOnly(endsOn);
    if (end.isBefore(start)) return DoctorLeaveSaveResult.invalidRange;

    final doctor = _hospitals.getDoctorById(doctorId);
    if (doctor == null || doctor.hospitalId != managerHospitalId) {
      return DoctorLeaveSaveResult.doctorNotManaged;
    }

    final leaves = load();
    final hasOverlap = leaves.any((leave) =>
        leave.id != leaveId &&
        leave.doctorId == doctorId &&
        leave.hospitalId == managerHospitalId &&
        !end.isBefore(leave.startsOn) &&
        !start.isAfter(leave.endsOn));
    if (hasOverlap) return DoctorLeaveSaveResult.overlaps;

    final leave = DoctorLeave(
      id: leaveId ?? 'leave-${DateTime.now().microsecondsSinceEpoch}',
      doctorId: doctorId,
      hospitalId: managerHospitalId,
      startsOn: start,
      endsOn: end,
      reason: normalizedReason,
    );
    final updated = leaves.where((item) => item.id != leave.id).toList()
      ..add(leave)
      ..sort((left, right) => left.startsOn.compareTo(right.startsOn));
    await _persist(updated);
    return DoctorLeaveSaveResult.saved;
  }

  Future<bool> cancel(String leaveId) async {
    if (!_isHospitalAdmin) return false;
    final leaves = load();
    final leave = leaves.where((item) => item.id == leaveId).firstOrNull;
    if (leave == null || leave.hospitalId != managerHospitalId) return false;
    final doctor = _hospitals.getDoctorById(leave.doctorId);
    if (doctor == null || doctor.hospitalId != managerHospitalId) return false;
    await _persist(leaves.where((item) => item.id != leaveId).toList());
    return true;
  }

  Future<void> _persist(List<DoctorLeave> leaves) => _storage.setString(
        StorageKeys.localDoctorLeaves,
        jsonEncode(leaves.map((leave) => leave.toJson()).toList()),
      );
}
