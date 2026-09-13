import 'package:app/core/components/async_widget.dart';
import 'package:app/ui/launch/view_models/launch_state.dart';
import 'package:app/ui/launch/view_models/launch_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 起動時の分岐点。読ませる内容はなく、オンボーディングかメイン画面へ振り分けるだけ。
/// 判定が終わるまでは何もない静かなページのままにする。
class LaunchPage extends ConsumerWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<LaunchState>>(launchViewModelProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        context.go(value.destination.route);
      }
    });

    return Scaffold(
      body: AsyncWidget(
        value: ref.watch(launchViewModelProvider),
        data: (_) => const SizedBox.shrink(),
      ),
    );
  }
}
