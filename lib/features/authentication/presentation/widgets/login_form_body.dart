import 'package:flutter/material.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import 'email_field.dart';
import 'forgot_password_button.dart';
import 'login_button.dart';
import 'password_field.dart';
import 'register_link.dart';
import 'social_login_section.dart';
import 'selected_role_badge.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginFormBody extends StatelessWidget {
  const LoginFormBody({
    required this.formKey,
    required this.onSubmit,
    required this.selectedRole,
  });

  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final String? selectedRole;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final maxWidth = width >= 700 ? 520.0 : double.infinity;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(context.tr('welcome_back'),
                      style: AppTextStyles.headlineLarge(context)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.tr('login_subtitle'),
                    style: AppTextStyles.bodyMedium(context),
                  ),
                  if (selectedRole != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    SelectedRoleBadge(role: selectedRole!),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  const EmailField(),
                  const SizedBox(height: AppSpacing.md),
                  const PasswordField(),
                  const SizedBox(height: AppSpacing.xs),
                  const ForgotPasswordButton(),
                  const SizedBox(height: AppSpacing.lg),
                  LoginButton(onPressed: onSubmit),
                  const SizedBox(height: AppSpacing.xl),
                  const SocialLoginSection(),
                  const Spacer(),
                  const SizedBox(height: AppSpacing.lg),
                  const RegisterLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
