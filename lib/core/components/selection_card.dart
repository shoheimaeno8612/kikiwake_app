import 'package:app/core/components/selection_surface.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

/// 選択式のカード。角丸・細い枠線・影なし。
///
/// ステップ 1、2、3-A、4 で共通して使い、違うのは中身だけ。
/// 高さは padding と中身で決まる。グリッドでは固定サイズではなく
/// `IntrinsicHeight` でカードの高さを揃える。
class SelectionCard extends StatelessWidget {
  const SelectionCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SelectionSurface(
      isSelected: isSelected,
      onTap: onTap,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardBorder),
      padding: padding,
      child: child,
    );
  }
}
