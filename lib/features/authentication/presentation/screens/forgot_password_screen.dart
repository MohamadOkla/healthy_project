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
import '../cubit/forgot_password_cubit.dart';
import '../cubit/forgot_password_state.dart';
import '../widgets/auth_back_app_bar.dart';
import '../widgets/login_background.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: const LoginBackground(child: _ForgotPasswordContent()),
    );
  }
}

class _ForgotPasswordContent extends StatelessWidget {
  const _ForgotPasswordContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AuthBackAppBar(
            title: 'استعادة كلمة المرور',
            onBackPressed: () => context.go(AppRoutes.login),
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
                    child:
                        BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'استعادة كلمة المرور',
                              style: AppTextStyles.headlineLarge(context),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'أدخل بريدك الإلكتروني أو رقم الهاتف لإرسال رمز التحقق.',
                              style: AppTextStyles.bodyMedium(context),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            const AppTextField(
                              label: 'البريد الإلكتروني أو رقم الهاتف',
                              prefixIcon: Icon(
                                Icons.alternate_email_rounded,
                                color: AppColors.primary,
                              ),
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            AppButton(
                              text: 'إرسال رمز التحقق',
                              isLoading: state.isLoading,
                              onPressed: () async {
                                await context
                                    .read<ForgotPasswordCubit>()
                                    .sendCode();
                                if (context.mounted) {
                                  context.go('${AppRoutes.otp}?purpose=reset');
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
