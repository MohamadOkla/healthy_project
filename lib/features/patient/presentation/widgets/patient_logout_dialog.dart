import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/user_role_helper.dart';

Future<void> showPatientLogoutDialog(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('تسجيل الخروج'),
      content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
      actions: [
        TextButton(
          onPressed: () => dialogContext.pop(false),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: () => dialogContext.pop(true),
          child: const Text('نعم'),
        ),
      ],
    ),
  );

  if (shouldLogout != true || !context.mounted) {
    return;
  }

  final selectedRole = LocalStorageService.instance.getString(
    StorageKeys.selectedRole,
  );
  await LocalStorageService.instance.remove(StorageKeys.isLoggedIn);
  await LocalStorageService.instance.remove(StorageKeys.currentUserRole);
  await LocalStorageService.instance.remove(StorageKeys.lastRoute);

  if (!context.mounted) {
    return;
  }

  if (selectedRole == null) {
    context.go(AppRoutes.roleSelection);
    return;
  }

  context.go(UserRoleHelper.loginRouteFor(selectedRole));
}
