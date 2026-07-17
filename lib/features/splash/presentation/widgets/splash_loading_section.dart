import 'package:flutter/material.dart';
import '../../../../core/widgets/app_loading_indicator.dart';

class SplashLoadingSection extends StatelessWidget {
  const SplashLoadingSection();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 36,
      child: Center(
        child: AppLoadingIndicator(),
      ),
    );
  }
}
