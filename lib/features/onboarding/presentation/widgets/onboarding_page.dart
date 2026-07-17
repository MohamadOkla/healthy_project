import 'package:flutter/material.dart';
import 'onboarding_illustration.dart';
import 'glass_info_card.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxHeight < 600;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OnboardingIllustration(icon: icon, isCompact: isCompact),
            SizedBox(height: isCompact ? AppSpacing.lg : AppSpacing.xl),
            GlassInfoCard(title: title, description: description),
          ],
        );
      },
    );
  }
}
