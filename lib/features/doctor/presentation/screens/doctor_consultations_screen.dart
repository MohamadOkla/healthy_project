import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../patient/data/repositories/consultations_repository_impl.dart';
import '../../data/repositories/doctor_repository_impl.dart';
import '../widgets/doctor_bottom_navigation.dart';

class DoctorConsultationsScreen extends StatelessWidget {
  const DoctorConsultationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final consultations =
        ConsultationsRepositoryImpl().getPendingConsultations();
    final doctorRepository = DoctorRepositoryImpl();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('استشارات المرضى'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.doctor),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: consultations.isEmpty
          ? const AppEmptyState(
              title: 'لا توجد استشارات بانتظار الرد',
              message: 'ستظهر هنا أي أسئلة يرسلها المرضى حول نتائجهم.',
              icon: Icons.forum_outlined,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: consultations.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final consultation = consultations[index];
                final patientName = doctorRepository
                        .getPatientById(consultation.patientId)
                        ?.name ??
                    'مريض';
                return AppCard(
                  onTap: () => context.go(
                    AppRoutes.doctorPatientDetail,
                    extra: consultation.patientId,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              consultation.subject,
                              style: AppTextStyles.titleMedium,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md),
                            ),
                            child: Text(
                              'بانتظار الرد',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.warning,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$patientName · ${consultation.dateLabel}',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        consultation.patientQuestion,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: const DoctorBottomNavigation(selectedIndex: 3),
    );
  }
}
