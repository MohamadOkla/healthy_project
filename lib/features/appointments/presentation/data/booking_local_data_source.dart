import 'package:flutter/material.dart';

import '../models/doctor_ui_model.dart';
import '../models/booking_ids.dart';
import '../models/time_slot_ui_model.dart';

/// Small deterministic local fixtures used by the booking flow.
class BookingLocalDataSource {
  static const specialties = SpecialtyId.values;
  static const hospitals = HospitalId.values;
  static const visitTypes = ['كشف جديد', 'متابعة', 'استشارة'];

  static const doctors = [
    DoctorUiModel(
        id: 'd1',
        name: 'د. أحمد خالد',
        specialtyId: SpecialtyId.cardiology,
        hospitalId: HospitalId.damascusUniversity,
        specialty: 'قلبية',
        hospital: 'مشفى دمشق الجامعي',
        rating: 4.8,
        experience: '12 سنة خبرة',
        icon: Icons.monitor_heart_rounded),
    DoctorUiModel(
        id: 'd2',
        name: 'د. رانيا يوسف',
        specialtyId: SpecialtyId.dermatology,
        hospitalId: HospitalId.alMouwasat,
        specialty: 'جلدية',
        hospital: 'مشفى المواساة',
        rating: 4.7,
        experience: '9 سنوات خبرة',
        icon: Icons.health_and_safety_rounded),
    DoctorUiModel(
        id: 'd3',
        name: 'د. سامر علي',
        specialtyId: SpecialtyId.orthopedics,
        hospitalId: HospitalId.alAssadUniversity,
        specialty: 'عظمية',
        hospital: 'مشفى الأسد الجامعي',
        rating: 4.6,
        experience: '10 سنوات خبرة',
        icon: Icons.accessibility_new_rounded),
    DoctorUiModel(
        id: 'd4',
        name: 'د. ليلى حسن',
        specialtyId: SpecialtyId.pediatrics,
        hospitalId: HospitalId.damascusUniversity,
        specialty: 'أطفال',
        hospital: 'مشفى دمشق الجامعي',
        rating: 4.9,
        experience: '14 سنة خبرة',
        icon: Icons.child_care_rounded),
    DoctorUiModel(
        id: 'd5',
        name: 'د. كريم منصور',
        specialtyId: SpecialtyId.cardiology,
        hospitalId: HospitalId.alMouwasat,
        specialty: 'قلبية',
        hospital: 'مشفى المواساة',
        rating: 4.5,
        experience: '8 سنوات خبرة',
        icon: Icons.monitor_heart_rounded),
    DoctorUiModel(
        id: 'd6',
        name: 'د. نور إبراهيم',
        specialtyId: SpecialtyId.cardiology,
        hospitalId: HospitalId.damascusUniversity,
        specialty: 'قلبية',
        hospital: 'مشفى دمشق الجامعي',
        rating: 4.6,
        experience: '7 سنوات خبرة',
        icon: Icons.monitor_heart_rounded),
  ];

  // Offsets are relative to today so fixtures never become stale. d3 has no
  // slots in the search window, which exercises the clear no-availability UX.
  static const Map<String, Map<int, List<(int, int)>>> availability = {
    'd1': {
      0: [(9, 0), (10, 30)],
      1: [(9, 0), (10, 30)],
      3: [(12, 30), (13, 0)]
    },
    'd2': {
      2: [(9, 30), (11, 0)],
      5: [(14, 0)]
    },
    'd3': {},
    'd4': {
      1: [(11, 15)],
      4: [(9, 0), (13, 30)]
    },
    'd5': {
      2: [(10, 0)],
      6: [(12, 0)]
    },
    'd6': {
      4: [(10, 30)]
    },
  };

  static DateTime dateAtOffset(int offset, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final today = DateTime(current.year, current.month, current.day);
    return today.add(Duration(days: offset));
  }

  static List<TimeSlotUiModel> slotsFor({
    required String doctorId,
    required DateTime date,
    DateTime? now,
    Iterable<DateTime> alreadyBooked = const [],
  }) {
    final today = now ?? DateTime.now();
    final normalized = DateTime(date.year, date.month, date.day);
    if (normalized.isBefore(DateTime(today.year, today.month, today.day))) {
      return const [];
    }
    final days = normalized
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
    final times = availability[doctorId]?[days] ?? const <(int, int)>[];
    return times.map((time) {
      final start = DateTime(date.year, date.month, date.day, time.$1, time.$2);
      final conflict =
          alreadyBooked.any((other) => other.isAtSameMomentAs(start));
      final available = start.isAfter(today) && !conflict;
      return TimeSlotUiModel(startAt: start, isAvailable: available);
    }).toList(growable: false);
  }

  static DateTime? earliestAvailable(String doctorId, {DateTime? now}) {
    final current = now ?? DateTime.now();
    for (var day = 0; day < 14; day++) {
      final date = dateAtOffset(day, now: current);
      final slot = slotsFor(doctorId: doctorId, date: date, now: current)
          .where((item) => item.isAvailable)
          .firstOrNull;
      if (slot != null) return slot.startAt;
    }
    return null;
  }
}
