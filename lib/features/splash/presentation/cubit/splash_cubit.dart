import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/user_role_helper.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  Timer? _timer;

  void start() {
    _timer?.cancel();
    _timer = Timer(AppDurations.splashDuration, () {
      if (!isClosed) {
        emit(SplashCompleted(resolveStartupRoute()));
      }
    });
  }

  static String resolveStartupRoute({LocalStorageService? storageService}) {
    final storage = storageService ?? LocalStorageService.instance;
    final hasSeenOnboarding = storage.getBool(StorageKeys.hasSeenOnboarding);
    final isLoggedIn = storage.getBool(StorageKeys.isLoggedIn);
    final currentUserRole = storage.getString(StorageKeys.currentUserRole);

    if (isLoggedIn == true && UserRoleHelper.isKnownRole(currentUserRole)) {
      return UserRoleHelper.dashboardRouteFor(currentUserRole);
    }

    if (hasSeenOnboarding != true) return AppRoutes.onboarding;
    return AppRoutes.login;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
