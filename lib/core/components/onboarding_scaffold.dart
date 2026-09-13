import 'package:app/core/extensions/edge_insets_ext.dart';
import 'package:flutter/material.dart';

/// オンボーディング各ステップの共通フレーム。
///
/// アートボードには 44px のヘッダーと固定の上下余白が描かれているが、
/// それはモック端末のステータスバーとホームインジケーターにあたる。
/// ここでは上端を標準の [AppBar]、下端を `withSafeBottom` で確保し、
/// 特定の端末サイズに依存しないようにしている。
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.body,
    required this.action,
    this.stepLabel,
    this.bodyPadding = const EdgeInsets.fromLTRB(18, 8, 18, 18),
    this.hasActionDivider = true,
  });

  final Widget body;

  /// 画面下部に固定する。選択しただけでは次へ進まない。
  final Widget action;

  /// `ステップ N/4`。ステップ数に含まれないアカウント画面では null。
  final String? stepLabel;

  final EdgeInsets bodyPadding;

  /// アカウント画面の下部アクションは控えめなスキップなので、区切り線を出さない。
  final bool hasActionDivider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: stepLabel == null ? null : Text(stepLabel!)),
      body: SingleChildScrollView(
        padding: bodyPadding.withSafeBottom(context),
        child: body,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasActionDivider) const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              10,
              18,
              6,
            ).withSafeBottom(context),
            child: action,
          ),
        ],
      ),
    );
  }
}
