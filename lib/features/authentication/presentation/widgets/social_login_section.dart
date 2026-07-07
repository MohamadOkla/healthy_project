import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('أو', style: AppTextStyles.bodyMedium(context)),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const Row(
          children: [
            Expanded(
              child: _SocialButton(
                label: 'Google',
                icon: Icons.g_mobiledata_rounded,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _SocialButton(
                label: 'Apple',
                icon: Icons.apple_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'تسجيل الدخول باستخدام $label',
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: AppColors.textDark),
        label: Text(
          label,
          style: AppTextStyles.bodyMedium(context).copyWith(color: Theme.of(context).colorScheme.onSurface),
          textDirection: TextDirection.ltr,
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          minimumSize: const Size(0, 52),
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          side: BorderSide(color: AppColors.textGrey.withValues(alpha: 0.18)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
        ),
      ),
    );
  }
}
