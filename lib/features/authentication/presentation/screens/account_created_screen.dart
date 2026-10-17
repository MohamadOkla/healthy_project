import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/user_role_helper.dart';
import '../widgets/auth_back_app_bar.dart';
import '../widgets/auth_success_card.dart';
import '../widgets/login_background.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key, this.selectedRole});

  final String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return LoginBackground(
      child: SafeArea(
        child: Column(
          children: [
            AuthBackAppBar(
              title: 'اكتمل التسجيل',
              onBackPressed: () =>
                  context.go(UserRoleHelper.loginRouteFor(selectedRole)),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: AuthSuccessCard(
                    title: switch (UserRoleHelper.normalize(selectedRole)) {
                      UserRoleHelper.doctor => 'تم إنشاء حساب الطبيب بنجاح',
                      UserRoleHelper.hospitalAdmin =>
                        'تم إنشاء حساب مدير المشفى بنجاح',
                      _ => 'تم إنشاء حساب المريض بنجاح',
                    },
                    message: switch (UserRoleHelper.normalize(selectedRole)) {
                      UserRoleHelper.doctor =>
                        'سيتم مراجعة الحساب من الإدارة، ويمكنك العودة إلى تسجيل الدخول.',
                      UserRoleHelper.hospitalAdmin =>
                        'يمكنك العودة إلى تسجيل الدخول باستخدام حساب إدارة المشفى.',
                      _ => 'يمكنك الآن تسجيل الدخول والوصول إلى خدماتك الطبية.',
                    },
                    buttonText: 'الانتقال إلى تسجيل الدخول',
                    onPressed: () async {
                      await LocalStorageService.instance.setBool(
                        StorageKeys.accountCreated,
                        true,
                      );
                      await LocalStorageService.instance.setString(
                        StorageKeys.lastRoute,
                        AppRoutes.login,
                      );
                      if (!context.mounted) return;
                      context.go(UserRoleHelper.loginRouteFor(selectedRole));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
