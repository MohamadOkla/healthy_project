import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

abstract final class ShareMockService {
  static Future<void> showShareSheet({
    required BuildContext context,
    required String title,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium(context).copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _ShareOption(
                  icon: Icons.email_rounded,
                  title: 'مشاركة عبر البريد الإلكتروني',
                  onTap: () => _completeShare(
                    rootContext: context,
                    sheetContext: sheetContext,
                    message: 'تمت مشاركة الملف عبر البريد الإلكتروني',
                  ),
                ),
                _ShareOption(
                  icon: Icons.chat_rounded,
                  title: 'مشاركة عبر واتساب',
                  onTap: () => _completeShare(
                    rootContext: context,
                    sheetContext: sheetContext,
                    message: 'تمت مشاركة الملف عبر واتساب',
                  ),
                ),
                _ShareOption(
                  icon: Icons.sms_rounded,
                  title: 'مشاركة عبر الرسائل',
                  onTap: () => _completeShare(
                    rootContext: context,
                    sheetContext: sheetContext,
                    message: 'تمت مشاركة الملف عبر الرسائل',
                  ),
                ),
                _ShareOption(
                  icon: Icons.link_rounded,
                  title: 'نسخ الرابط',
                  onTap: () => _completeShare(
                    rootContext: context,
                    sheetContext: sheetContext,
                    message: 'تم نسخ رابط المشاركة',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _completeShare({
    required BuildContext rootContext,
    required BuildContext sheetContext,
    required String message,
  }) {
    sheetContext.pop();
    ScaffoldMessenger.of(rootContext).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ShareOption extends StatelessWidget {
  const _ShareOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.10),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium(context)),
      trailing: const Icon(Icons.chevron_left_rounded),
      onTap: onTap,
    );
  }
}
