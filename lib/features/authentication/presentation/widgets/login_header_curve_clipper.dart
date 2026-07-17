import 'dart:ui';
import 'package:flutter/material.dart';

class LoginHeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 42)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + 28,
        size.width,
        size.height - 42,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
