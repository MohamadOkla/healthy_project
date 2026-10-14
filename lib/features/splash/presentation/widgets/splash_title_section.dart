import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashTitleSection extends StatelessWidget {
  const SplashTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.appNameEn,
            style: AppTextStyles.bodyMedium(context),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
