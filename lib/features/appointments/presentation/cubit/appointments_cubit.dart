import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local_appointments_repository.dart';
import '../models/appointment_status.dart';
import '../models/appointment_ui_model.dart';
import 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit({LocalAppointmentsRepository? repository})
      : super(AppointmentsState(appointments: [
          ..._fakeAppointments,
          ...(repository ?? LocalAppointmentsRepository()).load()
        ]));

  void changeStatus(AppointmentStatus status) {
    emit(state.copyWith(selectedStatus: status));
  }

  void searchAppointments(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void applyFilters({
    required AppointmentStatus status,
    String? specialty,
    String? date,
  }) {
    emit(
      state.copyWith(
        selectedStatus: status,
        specialtyFilter: specialty,
        dateFilter: date,
        clearSpecialtyFilter: specialty == null,
        clearDateFilter: date == null,
      ),
    );
  }

  void clearFilters() {
    emit(
      state.copyWith(
        searchQuery: '',
        selectedStatus: AppointmentStatus.confirmed,
        clearSpecialtyFilter: true,
        clearDateFilter: true,
      ),
    );
  }

  List<String> get specialties {
    return state.appointments
        .map((appointment) => appointment.specialty)
        .toSet()
        .toList(growable: false);
  }

  List<String> get dates {
    return state.appointments
        .map((appointment) => appointment.date)
        .toSet()
        .toList(growable: false);
  }

  static AppointmentUiModel get sampleAppointment => _fakeAppointments.first;

  static const List<AppointmentUiModel> _fakeAppointments = [
    AppointmentUiModel(
      id: '1',
      doctorName: 'د. أحمد خالد',
      specialty: 'قلبية',
      hospital: 'مشفى دمشق الجامعي',
      department: 'قسم القلبية',
      day: 'الثلاثاء',
      date: '18 يونيو 2026',
      time: '10:30 صباحاً',
      appointmentNumber: 'APT-2048',
      status: AppointmentStatus.confirmed,
      notes: 'يرجى الحضور قبل الموعد بعشر دقائق.',
      instructions: [
        'إحضار الهوية الشخصية.',
        'إحضار آخر تقارير أو تحاليل متوفرة.',
        'تجنب المشروبات المنبهة قبل الفحص بساعتين.',
      ],
    ),
    AppointmentUiModel(
      id: '2',
      doctorName: 'د. رانيا يوسف',
      specialty: 'جلدية',
      hospital: 'مشفى المواساة',
      department: 'قسم الجلدية',
      day: 'الأحد',
      date: '7 يونيو 2026',
      time: '09:00 صباحاً',
      appointmentNumber: 'APT-1964',
      status: AppointmentStatus.completed,
      notes: 'تمت الزيارة بنجاح.',
      instructions: ['متابعة العلاج حسب الوصفة الطبية.'],
    ),
    AppointmentUiModel(
      id: '3',
      doctorName: 'د. سامر علي',
      specialty: 'عظمية',
      hospital: 'مشفى الأسد الجامعي',
      department: 'قسم العظمية',
      day: 'الخميس',
      date: '28 مايو 2026',
      time: '01:00 مساءً',
      appointmentNumber: 'APT-1835',
      status: AppointmentStatus.completed,
      notes: 'تمت مراجعة صورة الأشعة.',
      instructions: ['الالتزام بتمارين العلاج الفيزيائي.'],
    ),
    AppointmentUiModel(
      id: '4',
      doctorName: 'د. ليلى حسن',
      specialty: 'أطفال',
      hospital: 'مشفى دمشق الجامعي',
      department: 'قسم الأطفال',
      day: 'الإثنين',
      date: '20 مايو 2026',
      time: '11:15 صباحاً',
      appointmentNumber: 'APT-1772',
      status: AppointmentStatus.canceled,
      notes: 'تم إلغاء الموعد بناءً على طلب المريض.',
      instructions: ['يمكن حجز موعد بديل من شاشة المواعيد.'],
    ),
  ];
}
