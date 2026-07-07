import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/reset_password_cubit.dart';
import '../cubit/reset_password_state.dart';
import '../widgets/auth_back_app_bar.dart';
import '../widgets/login_background.dart';
import '../widgets/password_strength_indicator.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(),
      child: const LoginBackground(child: _ResetPasswordContent()),
    );
  }
}

class _ResetPasswordContent extends StatelessWidget {
  const _ResetPasswordContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AuthBackAppBar(
            title: 'كلمة مرور جديدة',
            onBackPressed: () => context.go('${AppRoutes.otp}?purpose=reset'),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: context.colors.background,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'تعيين كلمة مرور جديدة',
                              style: AppTextStyles.headlineLarge(context),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'اختر كلمة مرور قوية لحماية حسابك.',
                              style: AppTextStyles.bodyMedium(context),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            AppTextField(
                              label: 'كلمة المرور الجديدة',
                              obscureText: true,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.primary,
                              ),
                              onChanged: context
                                  .read<ResetPasswordCubit>()
                                  .passwordChanged,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            PasswordStrengthIndicator(
                              password: state.password,
                              strength: state.strength,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const AppTextField(
                              label: 'تأكيد كلمة المرور',
                              obscureText: true,
                              prefixIcon: Icon(
                                Icons.verified_user_outlined,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            AppButton(
                              text: 'تحديث كلمة المرور',
                              isLoading: state.isLoading,
                              onPressed: () async {
                                await context
                                    .read<ResetPasswordCubit>()
                                    .submit();
                                if (context.mounted) {
                                  context.go(AppRoutes.passwordChanged);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
