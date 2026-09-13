import 'package:app/core/extensions/edge_insets_ext.dart';
import 'package:app/core/l10n/app_strings.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:app/domain/model/study_target.dart';
import 'package:app/domain/model/target_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 「その他」のチップから開くシート。選んだスコアを返す。
///
/// アートボードではこのピッカーは未定義だが、押しても何も起きないチップは
/// フローを壊してしまう。オンボーディングではキーボードもスライダーも
/// 使わない方針なので、スコアはドラッグではなくタップで選ぶ。
Future<TargetScore?> showTargetScoreSheet({
  required BuildContext context,
  required StudyTarget target,
}) {
  return showModalBottomSheet<TargetScore>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _TargetScoreSheet(target: target),
  );
}

class _TargetScoreSheet extends ConsumerWidget {
  const _TargetScoreSheet({required this.target});

  final StudyTarget target;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = TargetScore.pickerOptionsFor(target);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              ref.t('exam_score_sheet_title'),
              style: AppTypography.jp(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero.withSafeBottom(context),
              itemCount: options.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 20, endIndent: 20),
              itemBuilder: (context, index) {
                final score = options[index];
                return ListTile(
                  title: Text(
                    score.value,
                    style: AppTypography.mono(
                      fontSize: 17,
                      color: AppColors.ink,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(score),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
