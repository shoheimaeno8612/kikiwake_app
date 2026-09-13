import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// 質問文と、それを尋ねる理由を示す一文。
///
/// どのステップにも理由を添える。これがあるから、フローが単なる入力フォームに
/// 見えない。
class QuestionHeader extends StatelessWidget {
  const QuestionHeader({super.key, required this.title, this.rationale});

  final String title;
  final String? rationale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          title,
          style: AppTypography.jp(
            fontSize: AppTypography.displayJpSize,
            fontWeight: FontWeight.w700,
            height: AppTypography.displayJpHeight,
            color: AppColors.ink,
          ),
        ),
        if (rationale case final String text)
          Text(
            text,
            style: AppTypography.jp(
              fontSize: 13,
              height: AppTypography.bodyJpHeight,
              color: AppColors.inkQuiet,
            ),
          ),
      ],
    );
  }
}
