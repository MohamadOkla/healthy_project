import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_translations.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({super.key, required this.isLastPage});

  final bool isLastPage;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: isLastPage ? context.tr('get_started') : context.tr('next'),
      icon: isLastPage ? Icons.login_rounded : Icons.arrow_back_rounded,
      onPressed: context.read<OnboardingCubit>().next,
    );
  }
}
