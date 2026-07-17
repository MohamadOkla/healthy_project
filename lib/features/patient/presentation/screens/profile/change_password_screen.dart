import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientProfile),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('تغيير كلمة المرور'),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppTextField(
                  controller: _currentController,
                  label: 'كلمة المرور الحالية',
                  obscureText: !state.isCurrentPasswordVisible,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: cubit.toggleCurrentPasswordVisibility,
                    icon: Icon(
                      state.isCurrentPasswordVisible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'كلمة المرور الحالية مطلوبة'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _newController,
                  label: 'كلمة المرور الجديدة',
                  obscureText: !state.isNewPasswordVisible,
                  prefixIcon: const Icon(Icons.lock_reset_rounded),
                  suffixIcon: IconButton(
                    onPressed: cubit.toggleNewPasswordVisibility,
                    icon: Icon(
                      state.isNewPasswordVisible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 8)
                      ? 'كلمة المرور الجديدة لا تقل عن 8 أحرف'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _confirmController,
                  label: 'تأكيد كلمة المرور الجديدة',
                  obscureText: !state.isConfirmPasswordVisible,
                  prefixIcon: const Icon(Icons.verified_user_outlined),
                  suffixIcon: IconButton(
                    onPressed: cubit.toggleConfirmPasswordVisibility,
                    icon: Icon(
                      state.isConfirmPasswordVisible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  ),
                  validator: (value) => value != _newController.text
                      ? 'التأكيد يجب أن يطابق كلمة المرور الجديدة'
                      : null,
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  text: 'تحديث كلمة المرور',
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await context.read<ProfileCubit>().updatePassword();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تحديث كلمة المرور بنجاح')),
    );
    context.go(AppRoutes.patientProfile);
  }
}
