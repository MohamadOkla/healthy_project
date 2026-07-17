import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../medical_records/domain/entities/medical_record_entry.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class MedicalRecordsTab extends StatelessWidget {
  const MedicalRecordsTab({required this.records});

  final List<MedicalRecordEntry> records;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const AppEmptyState(
        title: 'لا توجد سجلات طبية بعد',
        message: 'اضغط زر الإضافة لتسجيل زيارة جديدة.',
        icon: Icons.assignment_outlined,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      itemCount: records.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final record = records[index];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      record.diagnosis,
                      style: AppTextStyles.titleMedium(context),
                    ),
                  ),
                  Text(record.visitDate, style: AppTextStyles.bodyMedium(context)),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${record.doctorName} · ${record.specialty} · ${record.hospital}',
                style: AppTextStyles.bodyMedium(context),
              ),
              if (record.symptoms.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text('الأعراض: ${record.symptoms}',
                    style: AppTextStyles.bodyMedium(context)),
              ],
              if (record.doctorNotes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text('ملاحظات: ${record.doctorNotes}',
                    style: AppTextStyles.bodyMedium(context)),
              ],
              if (record.vitals.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: record.vitals
                      .map(
                        (vital) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Text(
                            '${vital.$1}: ${vital.$2}',
                            style: AppTextStyles.bodyMedium(context).copyWith(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
