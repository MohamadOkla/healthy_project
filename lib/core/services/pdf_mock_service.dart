import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

abstract final class PdfMockService {
  static Future<void> createPdf({
    required BuildContext context,
    required String fileName,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.picture_as_pdf_rounded,
            color: AppColors.primary,
          ),
          title: const Text('تم إنشاء ملف PDF بنجاح'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fileName,
                style: AppTextStyles.titleMedium(context).copyWith(
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'هذا تنفيذ واجهة تجريبي لحين ربط خدمة الملفات الفعلية.',
                style: AppTextStyles.bodyMedium(context),
                textAlign: TextAlign.center,
              ),
            ],
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

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إنشاء $fileName بنجاح')),
    );
  }
}
