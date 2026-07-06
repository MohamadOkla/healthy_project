import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/user_role_helper.dart';

Future<void> showDoctorLogoutDialog(BuildContext context) async {
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

  await LocalStorageService.instance.remove(StorageKeys.isLoggedIn);
  await LocalStorageService.instance.remove(StorageKeys.currentUserRole);
  await LocalStorageService.instance.remove(StorageKeys.lastRoute);

  if (!context.mounted) return;
  context.go(UserRoleHelper.loginRouteFor(UserRoleHelper.doctor));
}
