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
import '../../../laboratory/domain/entities/lab_result_entry.dart';

const _fallbackResult = LabResultEntry(
  id: 'lab0',
  patientId: 'p1',
  testName: 'CBC + Vitamin D + HbA1c',
  testDate: '19 يونيو 2026',
  labName: 'مخبر مشفى دمشق الجامعي',
  isCompleted: true,
  summary: 'معظم القيم ضمن الطبيعي مع انخفاض بسيط في Vitamin D.',
  rows: [
    LabResultRow(
      name: 'Hemoglobin',
      value: '14.2 g/dL',
      normalRange: '13.5 - 17.5',
      isNormal: true,
    ),
    LabResultRow(
      name: 'Vitamin D',
      value: '18 ng/mL',
      normalRange: '30 - 100',
      isNormal: false,
    ),
  ],
  recommendation:
      'الالتزام بالمكملات، التعرض الآمن للشمس، ومراجعة الطبيب عند استمرار التعب.',
  doctorNotes: 'ينصح بإعادة فحص Vitamin D بعد 8 أسابيع من بدء العلاج.',
);

class LaboratoryResultDetailsScreen extends StatelessWidget {
  const LaboratoryResultDetailsScreen({super.key, this.result});

  final LabResultEntry? result;

  @override
  Widget build(BuildContext context) {
    final result = this.result ?? _fallbackResult;

    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: AppAppBar(
        title: 'تفاصيل نتيجة التحليل',
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutes.patientLaboratory);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _ResultHeaderCard(result: result),
          if (result.rows.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _ResultTableCard(rows: result.rows),
          ],
          if (result.recommendation.isNotEmpty ||
              result.doctorNotes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _InterpretationCard(result: result),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: 'تحميل PDF',
            icon: Icons.picture_as_pdf_rounded,
            onPressed: () => PdfMockService.createPdf(
              context: context,
              fileName: 'lab_result.pdf',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            text: 'مشاركة النتيجة',
            icon: Icons.share_rounded,
            isOutlined: true,
            onPressed: () => ShareMockService.showShareSheet(
              context: context,
              title: 'مشاركة نتيجة التحليل',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            text: 'طلب استشارة',
            icon: Icons.medical_services_rounded,
            isOutlined: true,
            onPressed: () => context.go(
              AppRoutes.patientRequestConsultation,
              extra: result,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultHeaderCard extends StatelessWidget {
  const _ResultHeaderCard({required this.result});

  final LabResultEntry result;

  @override
  Widget build(BuildContext context) {
    final hasAbnormal = result.rows.any((row) => !row.isNormal);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleRow(hasAbnormal: hasAbnormal),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(label: 'اسم التحليل', value: result.testName),
          _InfoRow(label: 'تاريخ التحليل', value: result.testDate),
          _InfoRow(label: 'المخبر أو المشفى', value: result.labName),
          _InfoRow(
            label: 'حالة النتيجة',
            value: result.isCompleted ? 'مكتملة' : 'قيد الإجراء',
          ),
          if (result.summary.isNotEmpty)
            _InfoRow(label: 'ملخص النتيجة', value: result.summary),
        ],
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.hasAbnormal});

  final bool hasAbnormal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.science_rounded, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'نتيجة التحليل',
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
          ),
        ),
        _StatusChip(
          label: hasAbnormal ? 'يحتاج متابعة' : 'طبيعي',
          color: hasAbnormal ? AppColors.warning : AppColors.success,
        ),
      ],
    );
  }
}

class _ResultTableCard extends StatelessWidget {
  const _ResultTableCard({required this.rows});

  final List<LabResultRow> rows;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('جدول النتائج', style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSpacing.md),
          ...rows.map(
            (row) => _LabResultRowTile(
              name: row.name,
              value: row.value,
              normalRange: row.normalRange,
              status: row.isNormal ? 'طبيعي' : 'غير طبيعي',
              color: row.isNormal ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _InterpretationCard extends StatelessWidget {
  const _InterpretationCard({required this.result});

  final LabResultEntry result;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[];
    if (result.summary.isNotEmpty) {
      sections.add(_SectionText(title: 'تفسير مختصر', value: result.summary));
    }
    if (result.doctorNotes.isNotEmpty) {
      sections.add(
        _SectionText(title: 'ملاحظات الطبيب', value: result.doctorNotes),
      );
    }
    if (result.recommendation.isNotEmpty) {
      sections.add(
        _SectionText(title: 'توصيات', value: result.recommendation),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < sections.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.md),
            sections[i],
          ],
        ],
      ),
    );
  }
}

class _LabResultRowTile extends StatelessWidget {
  const _LabResultRowTile({
    required this.name,
    required this.value,
    required this.normalRange,
    required this.status,
    required this.color,
  });

  final String name;
  final String value;
  final String normalRange;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(name, style: AppTextStyles.titleMedium)),
              _StatusChip(label: status, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(label: 'القيمة', value: value),
          _InfoRow(label: 'المجال الطبيعي', value: normalRange),
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
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: color)),
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
              width: 112, child: Text(label, style: AppTextStyles.bodyMedium)),
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
                AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
        const SizedBox(height: AppSpacing.sm),
        Text(value, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
