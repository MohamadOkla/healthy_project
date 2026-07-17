import 'package:flutter/material.dart';
import 'register_credentials_form.dart';
import 'register_personal_info_form.dart';
import 'register_profile_info_form.dart';

class RegisterStepBody extends StatelessWidget {
  const RegisterStepBody({
    required this.step,
    required this.isDoctorRegistration,
    required this.password,
    required this.onPasswordChanged,
  });

  final int step;
  final bool isDoctorRegistration;
  final String password;
  final ValueChanged<String> onPasswordChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      child: switch (step) {
        0 => const RegisterPersonalInfoForm(key: ValueKey('personal')),
        1 => RegisterProfileInfoForm(
            key: const ValueKey('profile'),
            isDoctorRegistration: isDoctorRegistration,
          ),
        _ => RegisterCredentialsForm(
            key: const ValueKey('credentials'),
            password: password,
            onPasswordChanged: onPasswordChanged,
          ),
      },
    );
  }
}
