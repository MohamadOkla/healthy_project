import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../laboratory/domain/entities/lab_result_entry.dart';
import '../../../medical_records/domain/entities/medical_record_entry.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';
import '../cubit/medical_timeline_cubit.dart';
import '../cubit/medical_timeline_state.dart';
import '../models/medical_timeline_event.dart';
import '../widgets/patient_bottom_navigation.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  late final MedicalTimelineCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = MedicalTimelineCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _cubit,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('السجل الطبي'),
            leading: IconButton(
              tooltip: 'رجوع',
              onPressed: () => context.go(AppRoutes.patientDashboard),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          bottomNavigationBar: const PatientBottomNavigation(selectedIndex: 0),
          body: BlocBuilder<MedicalTimelineCubit, MedicalTimelineState>(
            builder: (context, state) {
              if (state.isLoading && !state.hasLoaded) {
                return const AppLoading();
              }
              if (state.error != null && state.events.isEmpty) {
                return _errorState(context);
              }
              if (state.events.isEmpty) {
                return const AppEmptyState(
                  title: 'لا توجد أحداث طبية بعد',
                  message: 'ستظهر هنا زياراتك ووصفاتك ونتائج تحاليلك.',
                  icon: Icons.timeline_rounded,
                );
              }

              final events = context.read<MedicalTimelineCubit>().visibleEvents;
              if (events.isEmpty) return _filteredEmptyState(context);

              return RefreshIndicator(
                onRefresh: _cubit.refresh,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    Text('أحداثك الطبية',
                        style: AppTextStyles.headlineLarge(context)),
                    const SizedBox(height: AppSpacing.md),
                    _filters(context, state),
                    if (state.isLoading) ...[
                      const SizedBox(height: AppSpacing.md),
                      const LinearProgressIndicator(),
                    ],
                    if (state.error != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      const Text('تعذر تحديث البيانات. اسحب للتحديث مجددًا.'),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    ..._groupByDay(events).entries.expand((entry) => [
                          _dayHeading(context, entry.key),
                          const SizedBox(height: AppSpacing.sm),
                          ...entry.value.map((event) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: _eventCard(context, event),
                              )),
                          const SizedBox(height: AppSpacing.sm),
                        ]),
                  ],
                ),
              );
            },
          ),
        ),
      );

  Widget _errorState(BuildContext context) => AppEmptyState(
        title: 'تعذر تحميل السجل الطبي',
        message: 'تحقق من البيانات المحلية ثم حاول مرة أخرى.',
        icon: Icons.error_outline_rounded,
        action: AppButton(
          text: 'إعادة المحاولة',
          icon: Icons.refresh_rounded,
          onPressed: _cubit.load,
        ),
      );

  Widget _filteredEmptyState(BuildContext context) => AppEmptyState(
        title: 'لا توجد نتائج لهذه الفلاتر',
        message: 'جرّب إزالة بعض الفلاتر أو امسحها كلها.',
        icon: Icons.filter_alt_off_rounded,
        action: AppButton(
          text: 'مسح الفلاتر',
          icon: Icons.filter_alt_off_rounded,
          onPressed: _cubit.clearFilters,
        ),
      );

  Widget _filters(BuildContext context, MedicalTimelineState state) {
    final cubit = context.read<MedicalTimelineCubit>();
    final doctors = cubit.availableDoctors.toList();
    if (state.doctorFilter != null && !doctors.contains(state.doctorFilter)) {
      doctors.add(state.doctorFilter!);
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تصفية السجل', style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: TimelineTypeFilter.values.map((filter) {
              return FilterChip(
                label: Text(_typeLabel(filter)),
                selected: state.typeFilter == filter,
                onSelected: (_) => cubit.setTypeFilter(filter),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              OutlinedButton.icon(
                onPressed: () => _pickDate(context, state.startDate,
                    (date) => cubit.setStartDate(date), state.endDate),
                icon: const Icon(Icons.calendar_month_rounded),
                label: Text(state.startDate == null
                    ? 'من تاريخ'
                    : 'من ${_formatDate(state.startDate!)}'),
              ),
              OutlinedButton.icon(
                onPressed: () => _pickDate(context, state.endDate,
                    (date) => cubit.setEndDate(date), null,
                    firstDate: state.startDate),
                icon: const Icon(Icons.event_rounded),
                label: Text(state.endDate == null
                    ? 'إلى تاريخ'
                    : 'إلى ${_formatDate(state.endDate!)}'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<TimelineDoctorFilter?>(
            initialValue: state.doctorFilter,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'الطبيب',
              prefixIcon: Icon(Icons.person_search_rounded),
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<TimelineDoctorFilter?>(
                  value: null, child: Text('كل الأطباء')),
              ...doctors.map(
                (doctor) => DropdownMenuItem<TimelineDoctorFilter?>(
                  value: doctor,
                  child: Text(doctor.name, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
            onChanged: cubit.setDoctorFilter,
          ),
          if (_hasFilters(state)) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (state.typeFilter != TimelineTypeFilter.all)
                  InputChip(
                    label: Text(_typeLabel(state.typeFilter)),
                    onDeleted: cubit.clearTypeFilter,
                  ),
                if (state.startDate != null)
                  InputChip(
                    label: Text('من ${_formatDate(state.startDate!)}'),
                    onDeleted: cubit.clearStartDate,
                  ),
                if (state.endDate != null)
                  InputChip(
                    label: Text('إلى ${_formatDate(state.endDate!)}'),
                    onDeleted: cubit.clearEndDate,
                  ),
                if (state.doctorFilter != null)
                  InputChip(
                    label: Text(state.doctorFilter!.name),
                    onDeleted: cubit.clearDoctorFilter,
                  ),
                TextButton(
                  onPressed: cubit.clearFilters,
                  child: const Text('مسح الجميع'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    DateTime? current,
    bool Function(DateTime?) save,
    DateTime? maximum, {
    DateTime? firstDate,
  }) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: current ?? maximum ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: maximum ?? DateTime(2100),
      helpText: 'اختر التاريخ',
    );
    if (selected == null || !context.mounted) return;
    if (!save(selected)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('يجب أن يكون تاريخ البداية قبل النهاية.')));
    }
  }

  Widget _dayHeading(BuildContext context, String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(children: [
          const Icon(Icons.calendar_today_rounded,
              size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTextStyles.titleMedium(context)),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(child: Divider()),
        ]),
      );

  Widget _eventCard(BuildContext context, MedicalTimelineEvent event) {
    final color = _eventColor(event.type);
    final icon = _eventIcon(event.type);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_eventTypeLabel(event.type),
                      style: AppTextStyles.bodyMedium(context)
                          .copyWith(color: color, fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(event.title, style: AppTextStyles.titleMedium(context)),
                  if (event.doctorName != null && event.doctorName!.isNotEmpty)
                    Text('الطبيب: ${event.doctorName}',
                        style: AppTextStyles.bodyMedium(context)),
                  if (event.hospital != null && event.hospital!.isNotEmpty)
                    Text('المشفى/المخبر: ${event.hospital}',
                        style: AppTextStyles.bodyMedium(context)),
                ],
              ),
            ),
          ]),
          if (event.summary.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(event.summary, style: AppTextStyles.bodyMedium(context)),
          ],
          if (event.attachments.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            ...event.attachments.map((file) => Row(
                  children: [
                    const Icon(Icons.attach_file_rounded, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                        child: Text('مرفق مع هذا الحدث: ${file.fileName}',
                            style: AppTextStyles.bodyMedium(context))),
                  ],
                )),
          ],
          Material(
            // AppCard paints its surface with a decorated Container. Give the
            // ExpansionTile's ListTile its own Material so ink is painted
            // above that surface instead of being hidden by it.
            color: Colors.transparent,
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: const Text('معلومات إضافية'),
              children: [
                if (event.details != null && event.details!.isNotEmpty)
                  Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text(event.details!),
                      )),
                if (event.type == MedicalTimelineEventType.visit &&
                    event.originalEntry is MedicalRecordEntry)
                  _visitExtra(event.originalEntry as MedicalRecordEntry),
                if (event.type == MedicalTimelineEventType.prescription &&
                    event.originalEntry is PrescriptionEntry)
                  _prescriptionExtra(event.originalEntry as PrescriptionEntry),
                if (event.type == MedicalTimelineEventType.labResult &&
                    event.originalEntry is LabResultEntry)
                  _labExtra(event.originalEntry as LabResultEntry),
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: () => _openDetails(context, event),
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('فتح التفاصيل'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _visitExtra(MedicalRecordEntry record) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (record.specialty.isNotEmpty)
            Text('الاختصاص: ${record.specialty}'),
          if (record.vitals.isNotEmpty)
            Text('القياسات المسجلة: ${record.vitals.length}'),
          if (record.testsRequired.isNotEmpty)
            Text('تحاليل مطلوبة: ${record.testsRequired.join('، ')}'),
        ],
      );

  Widget _prescriptionExtra(PrescriptionEntry prescription) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('عدد الأدوية: ${prescription.medicines.length}'),
          if (prescription.expiryDate.isNotEmpty)
            Text('تنتهي في: ${prescription.expiryDate}'),
          if (prescription.warnings.isNotEmpty)
            Text('تحذيرات: ${prescription.warnings}'),
        ],
      );

  Widget _labExtra(LabResultEntry result) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(result.isCompleted
              ? 'حالة التحليل: مكتمل'
              : 'حالة التحليل: قيد الإجراء'),
          if (result.rows.isNotEmpty) Text('عدد القيم: ${result.rows.length}'),
          if (result.doctorNotes.isNotEmpty)
            Text('ملاحظات الطبيب: ${result.doctorNotes}'),
        ],
      );

  Future<void> _openDetails(
      BuildContext context, MedicalTimelineEvent event) async {
    final route = switch (event.type) {
      MedicalTimelineEventType.visit => AppRoutes.patientMedicalRecordDetails,
      MedicalTimelineEventType.prescription =>
        AppRoutes.patientPrescriptionDetails,
      MedicalTimelineEventType.labResult => AppRoutes.patientLaboratoryDetails,
    };
    await context.push(route, extra: event.originalEntry);
    if (!context.mounted) return;
    await _cubit.refresh();
  }

  Map<String, List<MedicalTimelineEvent>> _groupByDay(
      List<MedicalTimelineEvent> events) {
    final grouped = <String, List<MedicalTimelineEvent>>{};
    for (final event in events) {
      final key = event.occurredAt == null
          ? 'تاريخ غير محدد'
          : _formatDate(event.occurredAt!);
      grouped.putIfAbsent(key, () => []).add(event);
    }
    return grouped;
  }

  bool _hasFilters(MedicalTimelineState state) =>
      state.typeFilter != TimelineTypeFilter.all ||
      state.startDate != null ||
      state.endDate != null ||
      state.doctorFilter != null;

  String _typeLabel(TimelineTypeFilter type) => switch (type) {
        TimelineTypeFilter.all => 'الكل',
        TimelineTypeFilter.visits => 'زيارات',
        TimelineTypeFilter.prescriptions => 'وصفات',
        TimelineTypeFilter.labResults => 'تحاليل',
        TimelineTypeFilter.attachments => 'مرفقات',
      };

  String _eventTypeLabel(MedicalTimelineEventType type) => switch (type) {
        MedicalTimelineEventType.visit => 'زيارة طبيب',
        MedicalTimelineEventType.prescription => 'وصفة دوائية',
        MedicalTimelineEventType.labResult => 'نتيجة تحليل',
      };

  IconData _eventIcon(MedicalTimelineEventType type) => switch (type) {
        MedicalTimelineEventType.visit => Icons.medical_services_rounded,
        MedicalTimelineEventType.prescription => Icons.medication_rounded,
        MedicalTimelineEventType.labResult => Icons.science_rounded,
      };

  Color _eventColor(MedicalTimelineEventType type) => switch (type) {
        MedicalTimelineEventType.visit => AppColors.primary,
        MedicalTimelineEventType.prescription => AppColors.accentViolet,
        MedicalTimelineEventType.labResult => AppColors.accentBlue,
      };

  String _formatDate(DateTime date) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
