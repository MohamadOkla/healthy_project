import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/user_role_helper.dart';

class RegisterLink extends StatelessWidget {
  const RegisterLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(context.tr('no_account'),
            style: AppTextStyles.bodyMedium(context)),
        TextButton(
          onPressed: () {
            context.go(UserRoleHelper.registrationRoleSelectionRoute);
          },
          child: Text(
            context.tr('create_account'),
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
