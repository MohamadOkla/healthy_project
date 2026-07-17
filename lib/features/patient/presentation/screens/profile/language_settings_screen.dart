import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/cubit/app_settings_cubit.dart';
import '../../../../../app/cubit/app_settings_state.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientProfile),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('تغيير اللغة'),
      ),
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          final language = state.isArabic ? 'ar' : 'en';
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              RadioListTile<String>(
                value: 'ar',
                // ignore: deprecated_member_use
                groupValue: language,
                // ignore: deprecated_member_use
                onChanged: (value) => _changeLanguage(context, value),
                title: const Text('العربية'),
              ),
              RadioListTile<String>(
                value: 'en',
                // ignore: deprecated_member_use
                groupValue: language,
                // ignore: deprecated_member_use
                onChanged: (value) => _changeLanguage(context, value),
                title: const Text('English'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _changeLanguage(BuildContext context, String? value) async {
    if (value == null) return;
    await context.read<AppSettingsCubit>().changeLanguage(value);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value == 'ar'
            ? 'تم تغيير اللغة إلى العربية'
            : 'Language changed to English'),
      ),
    );
  }
}
