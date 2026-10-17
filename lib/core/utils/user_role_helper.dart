import '../constants/app_routes.dart';

abstract final class UserRoleHelper {
  static const patient = 'patient';
  static const doctor = 'doctor';
  static const hospitalAdmin = 'hospitalAdmin';

  static String normalize(String? role) {
    return switch (role) {
      'hospital_admin' => hospitalAdmin,
      'hospitalAdmin' => hospitalAdmin,
      'doctor' => doctor,
      _ => patient,
    };
  }

  static bool canSelfRegister(String? role) {
    return isKnownRole(role);
  }

  static bool isDoctor(String? role) => normalize(role) == doctor;

  static bool isHospitalAdmin(String? role) => normalize(role) == hospitalAdmin;

  static bool isKnownRole(String? role) =>
      role == patient ||
      role == doctor ||
      role == hospitalAdmin ||
      role == 'hospital_admin';

  static String loginRouteFor(String? role) {
    return Uri(
      path: AppRoutes.login,
      queryParameters: {'role': normalize(role)},
    ).toString();
  }

  static String registerRouteFor(String? role) {
    return Uri(
      path: AppRoutes.register,
      queryParameters: {'role': normalize(role)},
    ).toString();
  }

  static String get registrationRoleSelectionRoute => Uri(
        path: AppRoutes.roleSelection,
        queryParameters: const {'flow': 'register'},
      ).toString();

  static String otpRouteForRegister(String? role) {
    return Uri(
      path: AppRoutes.otp,
      queryParameters: {
        'purpose': 'register',
        'role': normalize(role),
      },
    ).toString();
  }

  static String accountCreatedRouteFor(String? role) {
    return Uri(
      path: AppRoutes.accountCreated,
      queryParameters: {'role': normalize(role)},
    ).toString();
  }

  static String dashboardRouteFor(String? role) {
    return switch (normalize(role)) {
      doctor => AppRoutes.doctor,
      hospitalAdmin => AppRoutes.hospitalAdmin,
      _ => AppRoutes.patientDashboard,
    };
  }
}
