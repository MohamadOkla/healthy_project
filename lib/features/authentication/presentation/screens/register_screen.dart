import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/register_cubit.dart';
import '../widgets/login_background.dart';
import '../widgets/register_content.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, this.selectedRole});

  final String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(selectedRole: selectedRole),
      child: const LoginBackground(child: RegisterContent()),
    );
  }
}
