import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/services/pdf_mock_service.dart';
import '../../../../core/services/share_mock_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';

const _fallbackPrescription = PrescriptionEntry(
  id: 'rx0',
  patientId: 'p1',
  doctorName: 'د. أحمد خالد',
  issueDate: '18 يونيو 2026',
  expiryDate: '18 يوليو 2026',
  isActive: true,
  medicines: [
    PrescriptionMedicine(
      name: 'Atorvastatin 20mg',
      dose: '20mg',
      frequency: 'مرة يومياً',
      duration: '30 يوم',
      instructions: 'يؤخذ مساءً بعد الطعام',
    ),
  ],
  notes: 'الالتزام بالجرعات ومراجعة الطبيب عند ظهور أي أعراض غير معتادة.',
  warnings:
      'تجنب إيقاف الدواء دون استشارة الطبيب. أخبر الطبيب في حال وجود حساسية دوائية.',
);

class PrescriptionDetailsScreen extends StatelessWidget {
  const PrescriptionDetailsScreen({super.key, this.prescription});

  final PrescriptionEntry? prescription;

  @override
  Widget build(BuildContext context) {
    final prescription = this.prescription ?? _fallbackPrescription;

    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: AppAppBar(
        title: 'تفاصيل الوصفة',
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutes.patientPrescriptions);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _PrescriptionHeader(prescription: prescription),
          const SizedBox(height: AppSpacing.md),
          _MedicineListCard(medicines: prescription.medicines),
          if (prescription.notes.isNotEmpty ||
              prescription.warnings.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _PrescriptionNotesCard(prescription: prescription),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: 'تحميل الوصفة',
            icon: Icons.download_rounded,
            onPressed: () => PdfMockService.createPdf(
              context: context,
              fileName: 'prescription.pdf',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            text: 'مشاركة الوصفة',
            icon: Icons.share_rounded,
            isOutlined: true,
            onPressed: () => ShareMockService.showShareSheet(
              context: context,
              title: 'مشاركة الوصفة الطبية',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            text: 'تذكير الدواء',
            icon: Icons.notifications_active_rounded,
            isOutlined: true,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تفعيل تذكير الدواء بنجاح')),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionHeader extends StatelessWidget {
  const _PrescriptionHeader({required this.prescription});

  final PrescriptionEntry prescription;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medication_rounded, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'الوصفة رقم ${prescription.id.toUpperCase()}',
                  style: AppTextStyles.titleMedium(context)
                      .copyWith(color: AppColors.primary),
                ),
              ),
              _StatusChip(
                label: prescription.isActive ? 'نشطة' : 'منتهية',
                color: prescription.isActive
                    ? AppColors.success
                    : AppColors.textGrey,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(label: 'اسم الطبيب', value: prescription.doctorName),
          _InfoRow(label: 'تاريخ الإصدار', value: prescription.issueDate),
          _InfoRow(
              label: 'تاريخ انتهاء الوصفة', value: prescription.expiryDate),
        ],
      ),
    );
  }
}

class _MedicineListCard extends StatelessWidget {
  const _MedicineListCard({required this.medicines});

  final List<PrescriptionMedicine> medicines;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('قائمة الأدوية', style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.md),
          ...medicines.map(
            (medicine) => _MedicineTile(
              name: medicine.name,
              dose: medicine.dose,
              frequency: medicine.frequency,
              duration: medicine.duration,
              instructions: medicine.instructions,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionNotesCard extends StatelessWidget {
  const _PrescriptionNotesCard({required this.prescription});

  final PrescriptionEntry prescription;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (prescription.notes.isNotEmpty)
            _SectionText(title: 'ملاحظات الطبيب', value: prescription.notes),
          if (prescription.notes.isNotEmpty && prescription.warnings.isNotEmpty)
            const SizedBox(height: AppSpacing.md),
          if (prescription.warnings.isNotEmpty)
            _SectionText(title: 'التحذيرات', value: prescription.warnings),
        ],
      ),
    );
  }
}

class _MedicineTile extends StatelessWidget {
  const _MedicineTile({
    required this.name,
    required this.dose,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });

  final String name;
  final String dose;
  final String frequency;
  final String duration;
  final String instructions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(label: 'الجرعة', value: dose),
          _InfoRow(label: 'عدد المرات', value: frequency),
          _InfoRow(label: 'مدة الاستخدام', value: duration),
          _InfoRow(label: 'تعليمات الاستخدام', value: instructions),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child:
          Text(label, style: AppTextStyles.bodyMedium(context).copyWith(color: color)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 110, child: Text(label, style: AppTextStyles.bodyMedium(context))),
          Expanded(
            child: Text(
              value,
              style:
                  AppTextStyles.bodyMedium(context).copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionText extends StatelessWidget {
  const _SectionText({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
                AppTextStyles.titleMedium(context).copyWith(color: AppColors.primary)),
        const SizedBox(height: AppSpacing.sm),
        Text(value, style: AppTextStyles.bodyMedium(context)),
      ],
    );
  }
}
