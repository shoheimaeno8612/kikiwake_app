import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `assets/lang/*.json` から読み込む、フラットなキー／値の文言カタログ。
///
/// ユーザーに見える文言はすべて JSON に置き、Dart のソースには書かない。
/// プレースホルダーは `{name}` と書き、[params] で埋める。
class AppStrings {
  const AppStrings(this._values);

  final Map<String, String> _values;

  static const _defaultAsset = 'assets/lang/ja.json';

  /// カタログを読み込んでデコードする。`runApp` の前に呼ぶことで、
  /// ラベルを出すためだけに画面がローディング状態を描かずに済む。
  static Future<AppStrings> load([String assetPath = _defaultAsset]) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return AppStrings({
      for (final entry in decoded.entries) entry.key: entry.value as String,
    });
  }

  String t(String key, {Map<String, String>? params}) {
    var value = _values[key] ?? key;
    if (params != null) {
      for (final entry in params.entries) {
        value = value.replaceAll('{${entry.key}}', entry.value);
      }
    }
    return value;
  }
}

/// `main()` でアセットから読み込んだカタログに差し替える。
final appStringsProvider = Provider<AppStrings>(
  (ref) => throw UnimplementedError('appStringsProvider must be overridden'),
);

extension AppStringsRef on WidgetRef {
  /// `read(appStringsProvider).t(...)` の省略形。カタログは実行中に変わらないので、
  /// watch ではなく read にしているのは意図的。
  String t(String key, {Map<String, String>? params}) =>
      read(appStringsProvider).t(key, params: params);
}
