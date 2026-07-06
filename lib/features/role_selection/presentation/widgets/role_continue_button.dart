import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/user_role_helper.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/role_selection_cubit.dart';
import '../cubit/role_selection_state.dart';

class RoleContinueButton extends StatelessWidget {
  const RoleContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleSelectionCubit, RoleSelectionState>(
      builder: (context, state) {
        return AppButton(
          text: 'متابعة',
          icon: Icons.arrow_back_rounded,
          onPressed: state.canContinue
              ? () async {
                  final role = state.selectedRole!;
                  final normalizedRole = UserRoleHelper.normalize(role.id);
                  await LocalStorageService.instance.setString(
                    StorageKeys.selectedRole,
                    normalizedRole,
                  );
                  if (!context.mounted) return;
                  context.go(UserRoleHelper.loginRouteFor(normalizedRole));
                }
              : null,
        );
      },
    );
  }
}
