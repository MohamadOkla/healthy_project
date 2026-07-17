import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import 'auth_back_app_bar.dart';
import 'register_step_indicator.dart';
import 'register_step_body.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/user_role_helper.dart';

class RegisterContent extends StatefulWidget {
  const RegisterContent();

  @override
  State<RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          return Column(
            children: [
              AuthBackAppBar(
                title: 'إنشاء حساب',
                onBackPressed: () {
                  if (state.isFirstStep) {
                    context
                        .go(UserRoleHelper.loginRouteFor(state.selectedRole));
                    return;
                  }
                  context.read<RegisterCubit>().previousStep();
                },
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: context.colors.background,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              state.isDoctorRegistration
                                  ? 'إنشاء حساب طبيب'
                                  : 'إنشاء حساب مريض',
                              style: AppTextStyles.headlineLarge(context),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              state.isDoctorRegistration
                                  ? 'أكمل بياناتك المهنية ليتم إنشاء الحساب ومراجعته من الإدارة.'
                                  : 'أكمل البيانات التالية لإنشاء حسابك داخل المنظومة.',
                              style: AppTextStyles.bodyMedium(context),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            RegisterStepIndicator(
                                currentStep: state.currentStep),
                            const SizedBox(height: AppSpacing.xl),
                            RegisterStepBody(
                              step: state.currentStep,
                              isDoctorRegistration: state.isDoctorRegistration,
                              password: _password,
                              onPasswordChanged: (value) =>
                                  setState(() => _password = value),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Row(
                              children: [
                                if (!state.isFirstStep) ...[
                                  Expanded(
                                    child: AppButton(
                                      text: 'السابق',
                                      isOutlined: true,
                                      onPressed: context
                                          .read<RegisterCubit>()
                                          .previousStep,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                ],
                                Expanded(
                                  child: AppButton(
                                    text: state.isLastStep
                                        ? 'إنشاء الحساب'
                                        : 'التالي',
                                    isLoading: state.isLoading,
                                    onPressed: () async {
                                      if (state.isLastStep) {
                                        await context
                                            .read<RegisterCubit>()
                                            .submit();
                                        await LocalStorageService.instance
                                            .setString(
                                          StorageKeys.selectedRole,
                                          state.selectedRole,
                                        );
                                        await LocalStorageService.instance
                                            .setString(
                                          StorageKeys.currentUserRole,
                                          state.selectedRole,
                                        );
                                        await LocalStorageService.instance
                                            .setString(
                                          StorageKeys.lastRoute,
                                          AppRoutes.otp,
                                        );
                                        if (context.mounted) {
                                          context.go(
                                            UserRoleHelper.otpRouteForRegister(
                                              state.selectedRole,
                                            ),
                                          );
                                        }
                                        return;
                                      }
                                      context.read<RegisterCubit>().nextStep();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
