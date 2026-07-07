import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.strength,
  });

  final String password;
  final int? strength;

  int get _score {
    if (strength != null) {
      return strength!.clamp(0, 4);
    }
    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final score = _score;
    final label = switch (score) {
      0 || 1 => 'ضعيفة',
      2 => 'متوسطة',
      3 => 'جيدة',
      _ => 'قوية',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 6,
                margin: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: index < score
                      ? AppColors.primary
                      : AppColors.textGrey.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text('قوة كلمة المرور: $label', style: AppTextStyles.bodyMedium(context)),
      ],
    );
  }
}
