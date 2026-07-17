import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../laboratory/domain/entities/lab_result_entry.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class LabResultsTab extends StatelessWidget {
  const LabResultsTab({required this.results});

  final List<LabResultEntry> results;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const AppEmptyState(
        title: 'لا توجد نتائج تحاليل بعد',
        message: 'اضغط زر الإضافة لتسجيل نتيجة تحليل جديدة.',
        icon: Icons.science_outlined,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final result = results[index];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      result.testName,
                      style: AppTextStyles.titleMedium(context),
                    ),
                  ),
                  Text(result.testDate, style: AppTextStyles.bodyMedium(context)),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(result.labName, style: AppTextStyles.bodyMedium(context)),
              const SizedBox(height: AppSpacing.sm),
              Text(result.summary, style: AppTextStyles.bodyMedium(context)),
              if (result.rows.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                ...result.rows.map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            row.name,
                            style: AppTextStyles.bodyMedium(context),
                          ),
                        ),
                        Text(
                          '${row.value}  (${row.normalRange})',
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: row.isNormal
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (result.recommendation.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'التوصية: ${result.recommendation}',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
