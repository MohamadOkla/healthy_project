import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import 'onboarding_illustration.dart';
import 'onboarding_indicator.dart';
import 'onboarding_next_button.dart';

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
                      return _OnboardingPage(
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

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxHeight < 600;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OnboardingIllustration(icon: icon, isCompact: isCompact),
            SizedBox(height: isCompact ? AppSpacing.lg : AppSpacing.xl),
            _GlassInfoCard(title: title, description: description),
          ],
        );
      },
    );
  }
}

class _GlassInfoCard extends StatelessWidget {
  const _GlassInfoCard({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border:
                  Border.all(color: AppColors.white.withValues(alpha: 0.70)),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineLarge(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium(context).copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
