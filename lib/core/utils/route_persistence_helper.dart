import '../constants/app_routes.dart';

abstract final class RoutePersistenceHelper {
  static const Set<String> _persistableRoutes = {
    AppRoutes.patientDashboard,
    AppRoutes.patientAppointments,
    AppRoutes.patientMedicalRecords,
    AppRoutes.patientPrescriptions,
    AppRoutes.patientLaboratory,
    AppRoutes.patientNotifications,
    AppRoutes.patientProfile,
    AppRoutes.patientSettings,
  };

  static const Set<String> _blockedStartupRoutes = {
    AppRoutes.splash,
    AppRoutes.onboarding,
    AppRoutes.roleSelection,
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
    AppRoutes.otp,
    AppRoutes.resetPassword,
    AppRoutes.accountCreated,
    AppRoutes.passwordChanged,
    AppRoutes.patientBookingSuccess,
  };

  static bool isPersistableRoute(String route) {
    return _persistableRoutes.contains(_normalize(route));
  }

  static bool isSafeStartupRoute(String? route) {
    if (route == null || route.isEmpty) {
      return false;
    }

    final normalizedRoute = _normalize(route);
    return normalizedRoute.startsWith('/patient/') &&
        !_blockedStartupRoutes.contains(normalizedRoute) &&
        isPersistableRoute(normalizedRoute);
  }

  static String _normalize(String route) {
    return Uri.tryParse(route)?.path ?? route;
  }
}
