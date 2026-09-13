import 'package:app/core/extensions/context_ext.dart';
import 'package:flutter/widgets.dart';

extension EdgeInsetsExt on EdgeInsets {
  /// [bottom] にホームインジケーターの高さを足す。`SafeArea` で包む代わりに使い、
  /// スクロールするコンテンツが画面端まで届くようにする。
  EdgeInsets withSafeBottom(BuildContext context) =>
      copyWith(bottom: bottom + context.safeAreaBottom);
}
