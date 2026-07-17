import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class BookingSelectionSection extends StatelessWidget {
  const BookingSelectionSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.md),
          Wrap(runSpacing: AppSpacing.sm, children: children),
        ],
      ),
    );
  }
}
