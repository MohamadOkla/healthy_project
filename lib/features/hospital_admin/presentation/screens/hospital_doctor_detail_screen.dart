import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/hospital_admin_repository_impl.dart';
import '../../domain/entities/hospital_doctor.dart';
import '../widgets/hospital_doctor_info_row.dart';
import '../widgets/hospital_doctor_stat_tile.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../appointments/data/doctor_leave.dart';
import '../../../appointments/data/doctor_leave_repository.dart';
import '../../domain/repositories/hospital_admin_repository.dart';

class HospitalDoctorDetailScreen extends StatefulWidget {
  const HospitalDoctorDetailScreen({
    super.key,
    required this.doctorId,
    this.repository,
    this.leaveRepository,
  });

  final String doctorId;
  final HospitalAdminRepository? repository;
  final DoctorLeaveRepository? leaveRepository;

  @override
  State<HospitalDoctorDetailScreen> createState() =>
      _HospitalDoctorDetailScreenState();
}

class _HospitalDoctorDetailScreenState
    extends State<HospitalDoctorDetailScreen> {
  late final HospitalAdminRepository _repository =
      widget.repository ?? HospitalAdminRepositoryImpl();
  late final DoctorLeaveRepository _leaveRepository =
      widget.leaveRepository ?? DoctorLeaveRepository(hospitals: _repository);
  HospitalDoctor? _doctor;
  DateTime? _startsOn;
  DateTime? _endsOn;
  String? _editingLeaveId;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _doctor = _repository.getDoctorById(widget.doctorId);
  }

  Future<void> _pickDate({required bool start}) async {
    final today = DoctorLeave.dateOnly(DateTime.now());
    final initialDate =
        start ? (_startsOn ?? today) : (_endsOn ?? _startsOn ?? today);
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: start ? 'اختر بداية الإجازة' : 'اختر نهاية الإجازة',
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (start) {
        _startsOn = DoctorLeave.dateOnly(selected);
        if (_endsOn != null && _endsOn!.isBefore(_startsOn!)) {
          _endsOn = null;
        }
      } else {
        _endsOn = DoctorLeave.dateOnly(selected);
      }
    });
  }

  Future<void> _saveLeave() async {
    final doctor = _doctor;
    final start = _startsOn;
    final end = _endsOn;
    if (doctor == null || start == null || end == null) {
      _showMessage('اختر تاريخ بداية الإجازة ونهايتها.');
      return;
    }
    if (_reasonController.text.trim().isEmpty) {
      _showMessage('أدخل سبب الإجازة.');
      return;
    }

    final result = await _leaveRepository.save(
      doctorId: doctor.id,
      startsOn: start,
      endsOn: end,
      reason: _reasonController.text,
      leaveId: _editingLeaveId,
    );
    if (!mounted) return;
    switch (result) {
      case DoctorLeaveSaveResult.saved:
        setState(() {
          _startsOn = null;
          _endsOn = null;
          _editingLeaveId = null;
          _reasonController.clear();
        });
        _showMessage('تم حفظ مدة الإجازة.');
        break;
      case DoctorLeaveSaveResult.notAuthorized:
        _showMessage('هذه العملية متاحة لمدير المشفى فقط.');
        break;
      case DoctorLeaveSaveResult.invalidRange:
        _showMessage('يجب ألا يسبق تاريخ النهاية تاريخ البداية.');
        break;
      case DoctorLeaveSaveResult.missingReason:
        _showMessage('أدخل سبب الإجازة.');
        break;
      case DoctorLeaveSaveResult.doctorNotManaged:
        _showMessage('لا يمكنك إدارة إجازة طبيب خارج مشفاك.');
        break;
      case DoctorLeaveSaveResult.overlaps:
        _showMessage('تتداخل هذه المدة مع إجازة أخرى مسجلة للطبيب.');
        break;
    }
  }

  Future<void> _cancelLeave(DoctorLeave leave) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إلغاء الإجازة'),
        content: Text('هل تريد إلغاء الإجازة من ${leave.formattedRange}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('تراجع'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('إلغاء الإجازة'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final removed = await _leaveRepository.cancel(leave.id);
    if (!mounted) return;
    if (removed) {
      setState(() {
        if (_editingLeaveId == leave.id) _clearEditor();
      });
      _showMessage('تم إلغاء الإجازة وتحديث المواعيد المتاحة.');
    } else {
      _showMessage('تعذر إلغاء الإجازة.');
    }
  }

  void _editLeave(DoctorLeave leave) {
    setState(() {
      _startsOn = leave.startsOn;
      _endsOn = leave.endsOn;
      _editingLeaveId = leave.id;
      _reasonController.text = leave.reason;
    });
  }

  void _clearEditor() {
    _startsOn = null;
    _endsOn = null;
    _editingLeaveId = null;
    _reasonController.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final doctor = _doctor;

    return Scaffold(
      appBar: AppBar(
        title: Text(doctor?.name ?? 'ملف الطبيب'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.hospitalAdminDoctors),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: doctor == null
          ? const AppEmptyState(
              title: 'تعذر إيجاد بيانات الطبيب',
              icon: Icons.person_off_rounded,
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppCard(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.12),
                        child: Text(
                          doctor.initials,
                          style: AppTextStyles.headlineLarge(context).copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(doctor.name,
                          style: AppTextStyles.headlineLarge(context)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(doctor.specialty,
                          style: AppTextStyles.bodyMedium(context)),
                      const SizedBox(height: AppSpacing.md),
                      HospitalDoctorInfoRow(
                          icon: Icons.phone_rounded, value: doctor.phone),
                      HospitalDoctorInfoRow(
                        icon: Icons.email_outlined,
                        value: doctor.email,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: HospitalDoctorStatTile(
                        label: 'عدد المرضى',
                        value: '${doctor.patientsCount}',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: HospitalDoctorStatTile(
                        label: 'مواعيد اليوم',
                        value: '${doctor.todayAppointmentsCount}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('إجازة الطبيب', style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'حدد مدة الإجازة. سيُمنع الحجز في يومي البداية والنهاية.',
                        style: AppTextStyles.bodyMedium(context),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'تُحفظ الإجازات محليًا وتُشارك بين الحسابات على هذا الجهاز فقط.',
                        style: AppTextStyles.bodyMedium(context),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton.icon(
                        onPressed: () => _pickDate(start: true),
                        icon: const Icon(Icons.event_rounded),
                        label: Text(_startsOn == null
                            ? 'تاريخ بداية الإجازة'
                            : 'البداية: ${DoctorLeave.formatDate(_startsOn!)}'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      OutlinedButton.icon(
                        onPressed: () => _pickDate(start: false),
                        icon: const Icon(Icons.event_available_rounded),
                        label: Text(_endsOn == null
                            ? 'تاريخ نهاية الإجازة'
                            : 'النهاية: ${DoctorLeave.formatDate(_endsOn!)}'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _reasonController,
                        label: 'سبب الإجازة',
                        hint: 'مثال: إجازة سنوية أو ظرف شخصي',
                        prefixIcon: const Icon(Icons.edit_note_rounded),
                        textInputAction: TextInputAction.done,
                        maxLines: 2,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        text: _editingLeaveId == null
                            ? 'حفظ الإجازة'
                            : 'حفظ التعديلات',
                        icon: Icons.save_rounded,
                        onPressed: _saveLeave,
                      ),
                      if (_editingLeaveId != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        TextButton(
                          onPressed: () => setState(_clearEditor),
                          child: const Text('إيقاف التعديل'),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('الإجازات المسجلة',
                    style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.sm),
                if (_leaveRepository.forDoctor(doctor.id).isEmpty)
                  const AppCard(
                    child: Text('لا توجد إجازات مسجلة لهذا الطبيب.'),
                  ),
                ..._leaveRepository.forDoctor(doctor.id).map(
                      (leave) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          child: Row(
                            children: [
                              const Icon(Icons.beach_access_rounded),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'من ${DoctorLeave.formatDate(leave.startsOn)} '
                                      'إلى ${DoctorLeave.formatDate(leave.endsOn)}',
                                      style: AppTextStyles.bodyMedium(context),
                                    ),
                                    if (leave.reason.isNotEmpty) ...[
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        'السبب: ${leave.reason}',
                                        style:
                                            AppTextStyles.bodyMedium(context),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: 'تعديل الإجازة',
                                onPressed: () => _editLeave(leave),
                                icon: const Icon(Icons.edit_calendar_rounded),
                              ),
                              IconButton(
                                tooltip: 'إلغاء الإجازة',
                                onPressed: () => _cancelLeave(leave),
                                icon: const Icon(Icons.delete_outline_rounded),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            ),
    );
  }
}
