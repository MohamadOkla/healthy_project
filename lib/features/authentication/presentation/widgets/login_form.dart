import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/local_storage_service.dart';
import '../cubit/login_cubit.dart';
import 'login_header.dart';
import 'login_form_body.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/user_role_helper.dart';

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
                    child: LoginFormBody(
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
