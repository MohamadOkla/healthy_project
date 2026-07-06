import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../features/patient/presentation/cubit/profile_cubit.dart';
import 'cubit/app_settings_cubit.dart';
import 'cubit/app_settings_state.dart';
import 'app_router.dart';

class DigitalHealthSystemApp extends StatelessWidget {
  const DigitalHealthSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppSettingsCubit()),
        // Provided once at the app root (rather than per-route) so a
        // patient's identity - name, contact info, health info,
        // notification preferences - is a single shared, live instance:
        // editing it anywhere (e.g. Edit Profile) is instantly reflected
        // everywhere else that reads it (dashboard greeting, drawer, doctor's
        // view of this patient), with no reload-from-storage gap.
        BlocProvider(create: (_) => ProfileCubit()),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appNameEn,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            routerConfig: AppRouter.router,
            locale: state.locale,
            builder: (context, child) {
              return Directionality(
                textDirection: state.textDirection,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
