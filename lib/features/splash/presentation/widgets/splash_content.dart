import 'package:flutter/material.dart';
import 'splash_logo.dart';
import 'splash_title_section.dart';
import 'splash_loading_section.dart';

class SplashContent extends StatelessWidget {
  const SplashContent();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          Spacer(),
          SplashLogo(),
          SizedBox(height: 28),
          SplashTitleSection(),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: SplashLoadingSection(),
          ),
        ],
      ),
    );
  }
}
