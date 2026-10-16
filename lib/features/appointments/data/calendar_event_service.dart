import 'package:flutter/services.dart';

import '../presentation/models/appointment_ui_model.dart';

const _calendarChannel = MethodChannel('healthy_app/calendar');

enum CalendarEventResult { opened, saved, cancelled, unavailable }

Future<CalendarEventResult> addAppointmentToCalendar(
    AppointmentUiModel appointment) async {
  final start = appointment.startAt;
  if (start == null) throw StateError('Appointment date is missing');
  final result = await _calendarChannel.invokeMethod<String>('createEvent', {
    'title': 'موعد ${appointment.doctorName}',
    'description':
        'موعد لدى ${appointment.doctorName} في ${appointment.hospital}',
    'location': appointment.hospital,
    'startMillis': start.millisecondsSinceEpoch,
    'endMillis': start
        .add(Duration(minutes: appointment.durationMinutes))
        .millisecondsSinceEpoch,
  });
  return switch (result) {
    'opened' => CalendarEventResult.opened,
    'saved' => CalendarEventResult.saved,
    'cancelled' => CalendarEventResult.cancelled,
    _ => CalendarEventResult.unavailable,
  };
}

String calendarEventFeedback(CalendarEventResult result) => switch (result) {
      CalendarEventResult.opened =>
        'تم فتح واجهة التقويم. أكمل إضافة الموعد أو ألغِه هناك.',
      CalendarEventResult.saved => 'تم حفظ الموعد في التقويم.',
      CalendarEventResult.cancelled => 'أُلغيت إضافة الموعد إلى التقويم.',
      CalendarEventResult.unavailable =>
        'لم يتمكن الجهاز من فتح واجهة التقويم.',
    };
