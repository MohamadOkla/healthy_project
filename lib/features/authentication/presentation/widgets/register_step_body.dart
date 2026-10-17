import 'package:flutter/material.dart';
import 'register_credentials_form.dart';
import 'register_personal_info_form.dart';
import 'register_profile_info_form.dart';

class RegisterStepBody extends StatelessWidget {
  const RegisterStepBody({
    required this.step,
    required this.isDoctorRegistration,
    required this.isHospitalAdminRegistration,
    required this.fullNameController,
    required this.phoneController,
    required this.emailController,
    required this.hospitalNameController,
    required this.jobTitleController,
    required this.password,
    required this.onPasswordChanged,
  });

  final int step;
  final bool isDoctorRegistration;
  final bool isHospitalAdminRegistration;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController hospitalNameController;
  final TextEditingController jobTitleController;
  final String password;
  final ValueChanged<String> onPasswordChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      child: switch (step) {
        0 => RegisterPersonalInfoForm(
            key: const ValueKey('personal'),
            fullNameController: fullNameController,
            phoneController: phoneController,
            emailController: emailController,
          ),
        1 => RegisterProfileInfoForm(
            key: const ValueKey('profile'),
            isDoctorRegistration: isDoctorRegistration,
            isHospitalAdminRegistration: isHospitalAdminRegistration,
            hospitalNameController: hospitalNameController,
            jobTitleController: jobTitleController,
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
