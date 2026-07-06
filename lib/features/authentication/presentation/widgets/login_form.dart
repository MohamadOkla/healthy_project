import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/user_role_helper.dart';
import '../cubit/login_cubit.dart';
import 'email_field.dart';
import 'forgot_password_button.dart';
import 'login_button.dart';
import 'login_header.dart';
import 'password_field.dart';
import 'register_link.dart';
import 'social_login_section.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, this.selectedRole});

  final String? selectedRole;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          top: false,
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: LoginHeader()),
              SliverFillRemaining(
                hasScrollBody: false,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _LoginFormBody(
                      formKey: _formKey,
                      onSubmit: _submit,
                      selectedRole: widget.selectedRole,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            child: Material(
              color: AppColors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: IconButton(
                tooltip: 'الرجوع لاختيار الدور',
                onPressed: () => context.go(AppRoutes.roleSelection),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final role = UserRoleHelper.normalize(widget.selectedRole);
      context.read<LoginCubit>().submit().then((_) async {
        if (mounted) {
          final targetRoute = UserRoleHelper.dashboardRouteFor(role);
          await LocalStorageService.instance.setBool(
            StorageKeys.isLoggedIn,
            true,
          );
          await LocalStorageService.instance.setString(
            StorageKeys.currentUserRole,
            role,
          );
          await LocalStorageService.instance.setString(
            StorageKeys.selectedRole,
            role,
          );
          await LocalStorageService.instance.setString(
            StorageKeys.lastRoute,
            targetRoute,
          );
          if (!mounted) return;
          context.go(targetRoute);
        }
      });
    }
  }
}

class _LoginFormBody extends StatelessWidget {
  const _LoginFormBody({
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
      decoration: const BoxDecoration(
        color: AppColors.background,
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
                  Text('أهلاً بعودتك', style: AppTextStyles.headlineLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'سجل دخولك للوصول إلى خدماتك الطبية بسهولة وأمان.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  if (selectedRole != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _SelectedRoleBadge(role: selectedRole!),
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
                  if (UserRoleHelper.canSelfRegister(selectedRole))
                    RegisterLink(selectedRole: selectedRole),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedRoleBadge extends StatelessWidget {
  const _SelectedRoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Text(
          'نوع الحساب: $role',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
