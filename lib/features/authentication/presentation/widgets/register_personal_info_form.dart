import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';

class RegisterPersonalInfoForm extends StatelessWidget {
  const RegisterPersonalInfoForm({
    super.key,
    required this.fullNameController,
    required this.phoneController,
    required this.emailController,
  });

  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: fullNameController,
          label: 'الاسم الكامل',
          prefixIcon: Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: phoneController,
          label: 'رقم الهاتف',
          prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: emailController,
          label: 'البريد الإلكتروني',
          prefixIcon: const Icon(
            Icons.mail_outline_rounded,
            color: AppColors.primary,
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          inputFormatters: Validators.emailInputFormatters,
          validator: Validators.validateEmail,
        ),
      ],
    );
  }
}
