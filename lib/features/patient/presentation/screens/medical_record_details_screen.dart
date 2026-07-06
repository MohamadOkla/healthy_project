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
import '../../../medical_records/domain/entities/medical_record_entry.dart';

const _fallbackRecord = MedicalRecordEntry(
  id: 'mr0',
  patientId: 'p1',
  doctorName: 'د. أحمد خالد',
  specialty: 'قلبية',
  hospital: 'مشفى دمشق الجامعي',
  visitDate: '18 يونيو 2026',
  diagnosis: 'اضطراب بسيط في ضغط الدم مع حالة مستقرة',
  symptoms: 'إرهاق خفيف، صداع متقطع، خفقان بسيط',
  doctorNotes: 'ينصح بالمتابعة بعد أسبوعين ومراقبة الضغط يومياً.',
  vitals: [
    ('الضغط', '120/80'),
    ('النبض', '78 bpm'),
    ('الحرارة', '36.8 C'),
    ('الوزن', '74 kg'),
  ],
);

class MedicalRecordDetailsScreen extends StatelessWidget {
  const MedicalRecordDetailsScreen({super.key, this.record});

  final MedicalRecordEntry? record;

  @override
  Widget build(BuildContext context) {
    final record = this.record ?? _fallbackRecord;

    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: AppAppBar(
        title: 'تفاصيل السجل الطبي',
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutes.patientMedicalRecords);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _VisitHeaderCard(record: record),
          const SizedBox(height: AppSpacing.md),
          _DiagnosisCard(record: record),
          if (record.vitals.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _VitalsCard(vitals: record.vitals),
          ],
          if (record.medications.isNotEmpty ||
              record.testsRequired.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _MedicalListsCard(record: record),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: 'تحميل التقرير',
            icon: Icons.download_rounded,
            onPressed: () => PdfMockService.createPdf(
              context: context,
              fileName: 'medical_record.pdf',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            text: 'مشاركة التقرير',
            icon: Icons.share_rounded,
            isOutlined: true,
            onPressed: () => ShareMockService.showShareSheet(
              context: context,
              title: 'مشاركة التقرير الطبي',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            text: 'رجوع',
            icon: Icons.arrow_back_rounded,
            isOutlined: true,
            onPressed: () => context.go(AppRoutes.patientMedicalRecords),
          ),
        ],
      ),
    );
  }
}

class _VisitHeaderCard extends StatelessWidget {
  const _VisitHeaderCard({required this.record});

  final MedicalRecordEntry record;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.assignment_rounded,
            title: 'معلومات الزيارة',
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(label: 'اسم الطبيب', value: record.doctorName),
          _InfoRow(label: 'الاختصاص', value: record.specialty),
          _InfoRow(label: 'اسم المشفى', value: record.hospital),
          _InfoRow(label: 'تاريخ الزيارة', value: record.visitDate),
        ],
      ),
    );
  }
}

class _DiagnosisCard extends StatelessWidget {
  const _DiagnosisCard({required this.record});

  final MedicalRecordEntry record;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.health_and_safety_rounded,
            title: 'التشخيص',
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(label: 'التشخيص', value: record.diagnosis),
          if (record.symptoms.isNotEmpty)
            _InfoRow(label: 'الأعراض', value: record.symptoms),
          if (record.doctorNotes.isNotEmpty)
            _InfoRow(label: 'ملاحظات الطبيب', value: record.doctorNotes),
        ],
      ),
    );
  }
}

class _VitalsCard extends StatelessWidget {
  const _VitalsCard({required this.vitals});

  final List<(String, String)> vitals;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.monitor_heart_rounded,
            title: 'العلامات الحيوية',
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: vitals
                .map((item) => _VitalChip(label: item.$1, value: item.$2))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _MedicalListsCard extends StatelessWidget {
  const _MedicalListsCard({required this.record});

  final MedicalRecordEntry record;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.medication_rounded,
            title: 'الخطة الطبية',
          ),
          const SizedBox(height: AppSpacing.md),
          if (record.medications.isNotEmpty) ...[
            _BulletList(title: 'الأدوية الموصوفة', items: record.medications),
            if (record.testsRequired.isNotEmpty)
              const SizedBox(height: AppSpacing.md),
          ],
          if (record.testsRequired.isNotEmpty)
            _BulletList(title: 'التحاليل المطلوبة', items: record.testsRequired),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
          ),
        ),
      ],
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
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 110, child: Text(label, style: AppTextStyles.bodyMedium)),
          Expanded(
            child: Text(
              value,
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _VitalChip extends StatelessWidget {
  const _VitalChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(item, style: AppTextStyles.bodyMedium)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
