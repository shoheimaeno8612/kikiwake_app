import 'package:flutter/widgets.dart';

extension ContextExt on BuildContext {
  /// ステータスバーの高さ。`SafeArea` が上端に確保する分。
  double get safeAreaTop => MediaQuery.of(this).padding.top;

  /// ホームインジケーターの高さ。`SafeArea` が下端に確保する分。
  double get safeAreaBottom => MediaQuery.of(this).padding.bottom;
}
