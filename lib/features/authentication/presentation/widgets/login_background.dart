import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -120,
              right: -90,
              child: _TransparentCircle(size: 280),
            ),
            const Positioned(
              top: 140,
              left: -130,
              child: _TransparentCircle(size: 260),
            ),
            const Positioned(
              bottom: -170,
              right: -110,
              child: _TransparentCircle(size: 340),
            ),
            SizedBox.expand(child: child),
          ],
        ),
      ),
    );
  }
}

class _TransparentCircle extends StatelessWidget {
  const _TransparentCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.11),
      ),
    );
  }
}
