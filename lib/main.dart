import 'package:app/core/l10n/app_strings.dart';
import 'package:app/main_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ラベルのためにローディング状態を描く画面が出ないよう、先に読み込んでおく。
  final strings = await AppStrings.load();

  runApp(
    ProviderScope(
      overrides: [appStringsProvider.overrideWithValue(strings)],
      child: const MainApp(),
    ),
  );
}
