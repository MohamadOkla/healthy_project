import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_translations.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return AppButton(
          text: context.tr('login_button'),
          isLoading: state.isLoading,
          onPressed: state.isLoading ? null : onPressed,
        );
      },
    );
  }
}
