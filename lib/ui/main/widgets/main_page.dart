import 'package:app/core/l10n/app_strings.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// オンボーディングを終えた学習者が着地する仮の画面。
/// 本来のホーム画面は別の作業で作る。
class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text(
          ref.t('main_placeholder'),
          style: AppTypography.jp(fontSize: 13, color: AppColors.inkQuiet),
        ),
      ),
    );
  }
}
