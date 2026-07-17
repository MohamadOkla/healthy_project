import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        return AppTextField(
          label: context.tr('password_label'),
          obscureText: !state.isPasswordVisible,
          textInputAction: TextInputAction.done,
          inputFormatters: Validators.passwordInputFormatters,
          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.primary,
          ),
          suffixIcon: IconButton(
            tooltip: state.isPasswordVisible
                ? 'إخفاء كلمة المرور'
                : 'إظهار كلمة المرور',
            onPressed: context.read<LoginCubit>().togglePasswordVisibility,
            icon: Icon(
              state.isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: context.colors.textSecondary,
            ),
          ),
          validator: Validators.validatePassword,
        );
      },
    );
  }
}
