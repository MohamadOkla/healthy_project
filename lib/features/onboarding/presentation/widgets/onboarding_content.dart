
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import 'onboarding_indicator.dart';
import 'onboarding_next_button.dart';
import 'onboarding_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingContent extends StatefulWidget {
  const OnboardingContent({super.key});

  @override
  State<OnboardingContent> createState() => _OnboardingContentState();
}

class _OnboardingContentState extends State<OnboardingContent> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listenWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex,
      listener: (context, state) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            state.currentIndex,
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: context.read<OnboardingCubit>().complete,
                    child: Text(
                      context.tr('skip'),
                      style: AppTextStyles.bodyMedium(context)
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: OnboardingCubit.pages.length,
                    onPageChanged: context.read<OnboardingCubit>().pageChanged,
                    itemBuilder: (context, index) {
                      final page = OnboardingCubit.pages[index];
                      return OnboardingPage(
                        key: ValueKey(page.title),
                        title: context.tr('onboarding_title_${index + 1}'),
                        description:
                            context.tr('onboarding_desc_${index + 1}'),
                        icon: page.icon,
                      );
                    },
                  ),
                ),
                OnboardingIndicator(
                  currentIndex: state.currentIndex,
                  itemCount: OnboardingCubit.pages.length,
                ),
                const SizedBox(height: AppSpacing.lg),
                OnboardingNextButton(isLastPage: state.isLastPage),
              ],
            ),
          ),
        );
      },
    );
  }
}
