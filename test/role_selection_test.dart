import 'package:healty_app/core/constants/app_routes.dart';
import 'package:healty_app/core/constants/storage_keys.dart';
import 'package:healty_app/core/services/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healty_app/core/utils/user_role_helper.dart';
import 'package:healty_app/features/role_selection/presentation/cubit/role_selection_cubit.dart';
import 'package:healty_app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:healty_app/features/authentication/presentation/cubit/register_cubit.dart';

void main() {
  test('account creation preserves all three roles and routes each to signup',
      () {
    final selection = RoleSelectionCubit();

    expect(selection.availableRoles.map((role) => role.id), [
      'patient',
      'doctor',
      'hospital_admin',
    ]);
    expect(selection.availableRoles, hasLength(3));
    expect(UserRoleHelper.registrationRoleSelectionRoute,
        '/role-selection?flow=register');
    expect(UserRoleHelper.registerRouteFor('patient'),
        '/auth/register?role=patient');
    expect(UserRoleHelper.registerRouteFor('doctor'),
        '/auth/register?role=doctor');
    expect(UserRoleHelper.registerRouteFor('hospital_admin'),
        '/auth/register?role=hospitalAdmin');

    selection.close();
  });

  test('startup opens login without a session and each valid session home',
      () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService.instance;
    await storage.init();
    await storage.clear();
    await storage.setBool(StorageKeys.hasSeenOnboarding, true);
    expect(SplashCubit.resolveStartupRoute(storageService: storage),
        AppRoutes.login);
    await storage.setBool(StorageKeys.hasSeenOnboarding, false);
    expect(SplashCubit.resolveStartupRoute(storageService: storage),
        AppRoutes.onboarding);

    await storage.setBool(StorageKeys.isLoggedIn, true);
    await storage.setString(StorageKeys.currentUserRole, UserRoleHelper.doctor);
    expect(SplashCubit.resolveStartupRoute(storageService: storage),
        AppRoutes.doctor);

    for (final (role, route) in [
      (UserRoleHelper.patient, AppRoutes.patientDashboard),
      (UserRoleHelper.doctor, AppRoutes.doctor),
      (UserRoleHelper.hospitalAdmin, AppRoutes.hospitalAdmin),
    ]) {
      await storage.setBool(StorageKeys.isLoggedIn, true);
      await storage.setString(StorageKeys.currentUserRole, role);
      expect(SplashCubit.resolveStartupRoute(storageService: storage), route);
    }

    await storage.setBool(StorageKeys.hasSeenOnboarding, true);
    await storage.setBool(StorageKeys.isLoggedIn, false);
    expect(SplashCubit.resolveStartupRoute(storageService: storage),
        AppRoutes.login);
  });

  test('registration persists role and basic user details', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService.instance;
    await storage.init();
    await storage.clear();
    final registration = RegisterCubit(selectedRole: 'hospital_admin');
    expect(registration.state.isHospitalAdminRegistration, isTrue);

    await registration.submit(
      fullName: 'اسم المدير',
      phone: '0500000000',
      email: 'admin@example.com',
      hospitalName: 'مشفى الاختبار',
      jobTitle: 'مدير إداري',
    );

    expect(storage.getString(StorageKeys.currentUserRole),
        UserRoleHelper.hospitalAdmin);
    expect(storage.getString(StorageKeys.profileFullName), 'اسم المدير');
    expect(storage.getString(StorageKeys.profilePhone), '0500000000');
    expect(storage.getString(StorageKeys.profileEmail), 'admin@example.com');
    expect(storage.getString(StorageKeys.profileHospitalName), 'مشفى الاختبار');
    expect(storage.getString(StorageKeys.profileJobTitle), 'مدير إداري');
    expect(storage.getBool(StorageKeys.isLoggedIn), isFalse);
    await registration.close();
  });
}
