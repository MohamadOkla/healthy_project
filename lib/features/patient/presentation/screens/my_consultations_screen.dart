import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/current_patient.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../data/repositories/consultations_repository_impl.dart';
import '../../domain/entities/consultation.dart';

class MyConsultationsScreen extends StatelessWidget {
  const MyConsultationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final consultations = ConsultationsRepositoryImpl()
        .getConsultationsForPatient(currentPatientId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientLaboratory),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('استشاراتي'),
      ),
      body: consultations.isEmpty
          ? const AppEmptyState(
              title: 'لا توجد استشارات بعد',
              message: 'اطلب استشارة من صفحة أي نتيجة تحليل لعرضها هنا.',
              icon: Icons.forum_outlined,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: consultations.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final consultation = consultations[index];
                return _ConsultationCard(consultation: consultation);
              },
            ),
    );
  }
}

class _ConsultationCard extends StatelessWidget {
  const _ConsultationCard({required this.consultation});

  final Consultation consultation;

  @override
  Widget build(BuildContext context) {
    final isAnswered = consultation.status == ConsultationStatus.answered;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  consultation.subject,
                  style: AppTextStyles.titleMedium(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: (isAnswered ? AppColors.success : AppColors.warning)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Text(
                  isAnswered ? 'تم الرد' : 'بانتظار الرد',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: isAnswered ? AppColors.success : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${consultation.doctorName} · ${consultation.dateLabel}',
            style: AppTextStyles.bodyMedium(context),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'سؤالك: ${consultation.patientQuestion}',
            style: AppTextStyles.bodyMedium(context),
          ),
          if (isAnswered && consultation.doctorAnswer != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Text(
                'رد الطبيب: ${consultation.doctorAnswer}',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
