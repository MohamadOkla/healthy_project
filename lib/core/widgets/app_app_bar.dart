import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor = AppColors.primary,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title == null
          ? null
          : Text(
              title!,
              style: AppTextStyles.titleMedium(context).copyWith(
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: AppColors.white),
      actionsIconTheme: const IconThemeData(color: AppColors.white),
    );
  }
}
