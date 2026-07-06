import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/route_persistence_helper.dart';
import '../../../../core/utils/user_role_helper.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  Timer? _timer;

  void start() {
    _timer?.cancel();
    _timer = Timer(AppDurations.splashDuration, () {
      if (!isClosed) {
        emit(SplashCompleted(_resolveStartupRoute()));
      }
    });
  }

  String _resolveStartupRoute() {
    final storage = LocalStorageService.instance;
    final hasSeenOnboarding = storage.getBool(StorageKeys.hasSeenOnboarding);
    final selectedRole = storage.getString(StorageKeys.selectedRole);
    final isLoggedIn = storage.getBool(StorageKeys.isLoggedIn);
    final currentUserRole = storage.getString(StorageKeys.currentUserRole);
    final lastRoute = storage.getString(StorageKeys.lastRoute);

    if (hasSeenOnboarding != true) {
      return AppRoutes.onboarding;
    }

    if (selectedRole == null) {
      return AppRoutes.roleSelection;
    }

    if (isLoggedIn != true) {
      return UserRoleHelper.loginRouteFor(selectedRole);
    }

    if (currentUserRole == null) {
      return AppRoutes.roleSelection;
    }

    if (UserRoleHelper.normalize(currentUserRole) == UserRoleHelper.patient) {
      if (RoutePersistenceHelper.isSafeStartupRoute(lastRoute)) {
        return lastRoute!;
      }
      return AppRoutes.patientDashboard;
    }

    return UserRoleHelper.dashboardRouteFor(currentUserRole);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
