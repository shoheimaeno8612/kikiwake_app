import 'package:app/core/l10n/app_strings.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 画面が [AsyncValue] をウィジェットに変換する唯一の窓口。
///
/// 初期表示の読み込みエラーはインラインで表示し、リトライボタンは置かない。
/// ローディングとエラーはページ地色の上に描くので、`Scaffold` の外、
/// ルート直下にそのまま置ける。
class AsyncWidget<T> extends StatelessWidget {
  const AsyncWidget({
    super.key,
    required this.value,
    required this.data,
    this.skipLoadingOnReload = false,
    this.skipLoadingOnRefresh = true,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final bool skipLoadingOnReload;
  final bool skipLoadingOnRefresh;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: skipLoadingOnReload,
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      data: data,
      loading: () => const _Ground(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _Ground(
        child: Consumer(
          builder: (context, ref, _) => Text(
            ref.t('common_error'),
            textAlign: TextAlign.center,
            style: AppTypography.jp(fontSize: 13, color: AppColors.inkQuiet),
          ),
        ),
      ),
    );
  }
}

class _Ground extends StatelessWidget {
  const _Ground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgPage,
      child: Center(child: child),
    );
  }
}
