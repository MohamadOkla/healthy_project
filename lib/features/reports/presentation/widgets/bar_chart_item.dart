import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BarChartItem {
  const BarChartItem({
    required this.label,
    required this.value,
    this.color = AppColors.primary,
  });

  final String label;
  final int value;
  final Color color;
}
