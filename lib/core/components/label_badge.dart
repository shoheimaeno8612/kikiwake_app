import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// 沈んだ地色に載せる、字間を広げた小さな等幅ラベル（`GENERAL`、`EXAM`、`B1`）。
class LabelBadge extends StatelessWidget {
  const LabelBadge({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
  });

  final String text;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        color: AppColors.bgSunken,
        borderRadius: AppRadius.chipBorder,
      ),
      child: Text(
        text,
        style: AppTypography.mono(
          fontSize: AppTypography.labelSize,
          color: AppColors.inkQuiet,
          letterSpacing: AppTypography.labelLetterSpacing,
          height: 1.2,
        ),
      ),
    );
  }
}
