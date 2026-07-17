import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/current_patient.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../laboratory/domain/entities/lab_result_entry.dart';
import '../../data/repositories/consultations_repository_impl.dart';
import '../widgets/consultation_info_row.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class ConsultationRequestScreen extends StatefulWidget {
  const ConsultationRequestScreen({super.key, this.labResult});

  final LabResultEntry? labResult;

  @override
  State<ConsultationRequestScreen> createState() =>
      _ConsultationRequestScreenState();
}

class _ConsultationRequestScreenState extends State<ConsultationRequestScreen> {
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labResult = widget.labResult;

    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: AppAppBar(
        title: 'طلب استشارة',
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
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConsultationInfoRow(
                  label: 'اسم التحليل',
                  value: labResult?.testName ?? 'استشارة عامة',
                ),
                if (labResult?.summary.isNotEmpty ?? false)
                  ConsultationInfoRow(label: 'ملخص النتيجة', value: labResult!.summary),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _questionController,
            label: 'اكتب سؤالك للطبيب',
            prefixIcon: const Icon(Icons.question_answer_rounded),
            maxLines: 5,
            textInputAction: TextInputAction.newline,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: 'إرسال طلب الاستشارة',
            icon: Icons.send_rounded,
            onPressed: _submitConsultation,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            text: 'استشاراتي',
            icon: Icons.forum_rounded,
            isOutlined: true,
            onPressed: () => context.go(AppRoutes.patientConsultations),
          ),
        ],
      ),
    );
  }

  Future<void> _submitConsultation() async {
    final question = _questionController.text.trim();
    ConsultationsRepositoryImpl().addConsultation(
      patientId: currentPatientId,
      doctorName: 'د. سارة منصور',
      subject: widget.labResult?.testName ?? 'استشارة عامة',
      patientQuestion:
          question.isEmpty ? 'أرغب بمعرفة المزيد حول هذه النتيجة.' : question,
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
          ),
          title: const Text('تم إرسال طلب الاستشارة بنجاح'),
          content: Text(
            'وسوف يتم الرد من الطبيب لاحقاً.',
            style: AppTextStyles.bodyMedium(context),
          ),
          actions: [
            FilledButton(
              onPressed: dialogContext.pop,
              child: const Text('تم'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    context.go(AppRoutes.patientConsultations);
  }
}
