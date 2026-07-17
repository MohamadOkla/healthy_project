import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class AdminDashboardHeader extends StatelessWidget {
  const AdminDashboardHeader({required this.hospitalName});

  final String hospitalName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: const Icon(
            Icons.local_hospital_rounded,
            color: AppColors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hospitalName,
                style: AppTextStyles.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'نظرة عامة على نشاط المشفى اليوم',
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
