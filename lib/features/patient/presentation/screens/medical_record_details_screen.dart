import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../medical_records/domain/entities/medical_record_entry.dart';
import '../widgets/visit_header_card.dart';
import '../widgets/diagnosis_card.dart';
import '../widgets/vitals_card.dart';
import '../widgets/medical_lists_card.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/services/medical_document_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/medical_document_action_button.dart';

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
    final documentService = MedicalDocumentService();
    final fileName = MedicalDocumentService.safeFileName(
      'medical_record',
      record.id,
    );

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
          VisitHeaderCard(record: record),
          const SizedBox(height: AppSpacing.md),
          DiagnosisCard(record: record),
          if (record.vitals.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            VitalsCard(vitals: record.vitals),
          ],
          if (record.medications.isNotEmpty ||
              record.testsRequired.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            MedicalListsCard(record: record),
          ],
          const SizedBox(height: AppSpacing.xl),
          MedicalDocumentActionButton(
            service: documentService,
            createPdf: () => documentService.createMedicalRecordPdf(record),
            fileName: fileName,
            title: 'السجل الطبي',
            action: MedicalDocumentAction.save,
            buttonText: 'تحميل التقرير',
            icon: Icons.download_rounded,
          ),
          const SizedBox(height: AppSpacing.sm),
          MedicalDocumentActionButton(
            service: documentService,
            createPdf: () => documentService.createMedicalRecordPdf(record),
            fileName: fileName,
            title: 'السجل الطبي',
            action: MedicalDocumentAction.share,
            buttonText: 'مشاركة التقرير',
            icon: Icons.share_rounded,
            isOutlined: true,
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
