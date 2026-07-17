import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/user_role_helper.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/otp_cubit.dart';
import '../cubit/otp_state.dart';
import '../widgets/auth_back_app_bar.dart';
import '../widgets/login_background.dart';
import '../widgets/otp_input.dart';
import '../widgets/resend_code_button.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({
    super.key,
    required this.purpose,
    this.selectedRole,
  });

  final String purpose;
  final String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(),
      child: LoginBackground(
        child: _OtpContent(purpose: purpose, selectedRole: selectedRole),
      ),
    );
  }
}

class _OtpContent extends StatelessWidget {
  const _OtpContent({required this.purpose, this.selectedRole});

  final String purpose;
  final String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AuthBackAppBar(
            title: 'رمز التحقق',
            onBackPressed: () {
              context.go(
                purpose == 'register'
                    ? UserRoleHelper.registerRouteFor(selectedRole)
                    : AppRoutes.forgotPassword,
              );
            },
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
                    child: BlocBuilder<OtpCubit, OtpState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'رمز التحقق',
                              style: AppTextStyles.headlineLarge(context),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'أدخل الرمز المكون من 6 خانات للمتابعة.',
                              style: AppTextStyles.bodyMedium(context),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            OtpInput(
                              onChanged: context.read<OtpCubit>().codeChanged,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            ResendCodeButton(
                              remainingSeconds: state.remainingSeconds,
                              onPressed: context.read<OtpCubit>().resend,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            AppButton(
                              text: 'تحقق',
                              isLoading: state.isVerifying,
                              onPressed: state.isComplete
                                  ? () async {
                                      await context.read<OtpCubit>().verify();
                                      await LocalStorageService.instance
                                          .setBool(
                                        StorageKeys.otpVerified,
                                        true,
                                      );
                                      if (!context.mounted) return;
                                      context.go(
                                        purpose == 'register'
                                            ? UserRoleHelper
                                                .accountCreatedRouteFor(
                                                selectedRole,
                                              )
                                            : AppRoutes.resetPassword,
                                      );
                                    }
                                  : null,
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
