import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';
import '../widgets/prescription_header.dart';
import '../widgets/medicine_list_card.dart';
import '../widgets/prescription_notes_card.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/services/pdf_mock_service.dart';
import '../../../../core/services/share_mock_service.dart';
import '../../../../core/theme/app_spacing.dart';

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
          PrescriptionHeader(prescription: prescription),
          const SizedBox(height: AppSpacing.md),
          MedicineListCard(medicines: prescription.medicines),
          if (prescription.notes.isNotEmpty ||
              prescription.warnings.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            PrescriptionNotesCard(prescription: prescription),
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
