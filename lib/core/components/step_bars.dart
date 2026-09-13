import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// 量を示すメーターとして使う、小さなバーの並び。
///
/// ステップ 1 では 5 本を縦に積んでレベルの位置を示し、
/// ステップ 4 では 6 本を横に並べて目標に必要な時間を示す。
/// 縦向きは下から、横向きは左から塗る。
class StepBars extends StatelessWidget {
  const StepBars({
    super.key,
    required this.filled,
    required this.total,
    required this.barWidth,
    required this.barHeight,
    required this.spacing,
    required this.axis,
    this.emptyColor = AppColors.sand5,
    this.filledColor = AppColors.ink,
    this.radius = 2,
  });

  final int filled;
  final int total;
  final double barWidth;
  final double barHeight;
  final double spacing;
  final Axis axis;
  final Color emptyColor;
  final Color filledColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final bars = List.generate(
      total,
      (index) => Container(
        width: barWidth,
        height: barHeight,
        decoration: BoxDecoration(
          color: index < filled ? filledColor : emptyColor,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );

    return axis == Axis.vertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing,
            // 上方向に積み、最初のバーを一番下に置く。
            verticalDirection: VerticalDirection.up,
            children: bars,
          )
        : Row(mainAxisSize: MainAxisSize.min, spacing: spacing, children: bars);
  }
}
