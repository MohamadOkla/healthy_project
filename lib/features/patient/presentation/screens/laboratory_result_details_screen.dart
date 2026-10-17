import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../laboratory/domain/entities/lab_result_entry.dart';
import '../widgets/result_header_card.dart';
import '../widgets/result_table_card.dart';
import '../widgets/interpretation_card.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/services/medical_document_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/medical_document_action_button.dart';

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
    final documentService = MedicalDocumentService();
    final fileName =
        MedicalDocumentService.safeFileName('lab_result', result.id);

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
          ResultHeaderCard(result: result),
          if (result.rows.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            ResultTableCard(rows: result.rows),
          ],
          if (result.recommendation.isNotEmpty ||
              result.doctorNotes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            InterpretationCard(result: result),
          ],
          const SizedBox(height: AppSpacing.xl),
          MedicalDocumentActionButton(
            service: documentService,
            createPdf: () => documentService.createLabResultPdf(result),
            fileName: fileName,
            title: 'نتيجة التحليل',
            action: MedicalDocumentAction.save,
            buttonText: 'تحميل PDF',
            icon: Icons.picture_as_pdf_rounded,
          ),
          const SizedBox(height: AppSpacing.sm),
          MedicalDocumentActionButton(
            service: documentService,
            createPdf: () => documentService.createLabResultPdf(result),
            fileName: fileName,
            title: 'نتيجة التحليل',
            action: MedicalDocumentAction.share,
            buttonText: 'مشاركة النتيجة',
            icon: Icons.share_rounded,
            isOutlined: true,
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
