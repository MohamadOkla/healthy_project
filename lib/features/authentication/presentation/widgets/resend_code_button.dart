import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ResendCodeButton extends StatelessWidget {
  const ResendCodeButton({
    super.key,
    required this.remainingSeconds,
    required this.onPressed,
  });

  final int remainingSeconds;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final canResend = remainingSeconds == 0;
    return TextButton(
      onPressed: canResend ? onPressed : null,
      child: Text(
        canResend
            ? 'إعادة إرسال الرمز'
            : 'إعادة الإرسال خلال $remainingSeconds ثانية',
        style: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.primary),
      ),
    );
  }
}
