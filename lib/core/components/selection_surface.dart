import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_motion.dart';
import 'package:flutter/material.dart';

/// 選択式コントロールの土台になる、唯一のタップ可能な面。
///
/// プロダクト内で彩度を持つのは選択状態だけ。アクセントの背景と枠線が
/// チェックと同時に現れ、画面上のほかの要素は変化しない。[Material] が
/// 自前で色と形をアニメーションするので、明示的なアニメーションなしで
/// デザインシステムの 120ms の遷移になり、インクのスプラッシュも残る。
class SelectionSurface extends StatelessWidget {
  const SelectionSurface({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.shape,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final bool isSelected;
  final VoidCallback onTap;

  /// カード用の角丸矩形。枠線の色はここで付けるので、
  /// side を持たない形を渡すこと。
  final OutlinedBorder shape;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      animationDuration: AppMotion.durQuiet,
      color: isSelected ? AppColors.accentBg : AppColors.bgRaised,
      shape: shape.copyWith(
        side: BorderSide(
          color: isSelected ? AppColors.accentBorder : AppColors.line,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
