import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_motion.dart';
import 'package:flutter/material.dart';

/// 選択式カードの末尾に置く丸いチェック。
///
/// 選択時にレイアウトがずれないよう常に場所を確保しておき、
/// 塗りとチェックだけを出し入れする。
class SelectionCheck extends StatelessWidget {
  const SelectionCheck({super.key, required this.isSelected, this.size = 20});

  final bool isSelected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.durQuiet,
      curve: AppMotion.easeQuiet,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.accentSolid : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.accentSolid : AppColors.checkOutline,
        ),
      ),
      child: Icon(
        Icons.check,
        size: size * 0.58,
        color: isSelected ? AppColors.sand1 : Colors.transparent,
      ),
    );
  }
}
