import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/role_selection_cubit.dart';
import '../cubit/role_selection_state.dart';
import '../widgets/role_card.dart';
import '../widgets/role_continue_button.dart';
import '../widgets/role_selection_background.dart';
import '../widgets/role_selection_header.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key, this.forRegistration = false});

  final bool forRegistration;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoleSelectionCubit(),
      child: RoleSelectionBackground(
        child: _RoleSelectionContent(forRegistration: forRegistration),
      ),
    );
  }
}

class _RoleSelectionContent extends StatelessWidget {
  const _RoleSelectionContent({required this.forRegistration});

  final bool forRegistration;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth =
              constraints.maxWidth >= 700 ? 560.0 : double.infinity;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: IconButton(
                        tooltip: 'العودة إلى تسجيل الدخول',
                        onPressed: () => context.go(AppRoutes.login),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                    const RoleSelectionHeader(),
                    const SizedBox(height: AppSpacing.lg),
                    Expanded(
                      child:
                          BlocBuilder<RoleSelectionCubit, RoleSelectionState>(
                        builder: (context, state) {
                          return ListView.separated(
                            itemCount: context
                                .read<RoleSelectionCubit>()
                                .availableRoles
                                .length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final role = context
                                  .read<RoleSelectionCubit>()
                                  .availableRoles[index];
                              return RoleCard(
                                role: role,
                                isSelected: state.selectedRole?.id == role.id,
                                onTap: () => context
                                    .read<RoleSelectionCubit>()
                                    .selectRole(role),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    RoleContinueButton(forRegistration: forRegistration),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
