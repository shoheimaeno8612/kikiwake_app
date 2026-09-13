import 'package:app/core/components/async_widget.dart';
import 'package:app/core/components/onboarding_scaffold.dart';
import 'package:app/core/components/question_header.dart';
import 'package:app/core/l10n/app_strings.dart';
import 'package:app/core/router/routes.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:app/domain/model/exam_date.dart';
import 'package:app/domain/model/onboarding_answers.dart';
import 'package:app/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// アカウント作成。ステップ数には含まない。
///
/// スキップも正式な選択肢として扱う。ここまでの回答はゲストとして端末に残り、
/// あとでアカウントを作ったときに引き継ぐ想定。
class OnboardingAccountPage extends ConsumerWidget {
  const OnboardingAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncWidget(
      value: ref.watch(onboardingViewModelProvider),
      data: (state) => OnboardingScaffold(
        hasActionDivider: false,
        action: TextButton(
          onPressed: () => context.go(Routes.main),
          child: Text(ref.t('account_skip')),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 18,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 26,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 22,
                  children: [
                    QuestionHeader(
                      title: ref.t('account_title'),
                      rationale: ref.t('account_description'),
                    ),
                    _AnswerSummary(answers: state.answers),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 10,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.go(Routes.main),
                      child: Text(ref.t('account_apple')),
                    ),
                    OutlinedButton(
                      onPressed: () => context.go(Routes.main),
                      child: Text(ref.t('account_google')),
                    ),
                    OutlinedButton(
                      onPressed: () => context.go(Routes.main),
                      child: Text(ref.t('account_email')),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text.rich(
                _fillTemplate(
                  ref.t('account_terms'),
                  AppTypography.jp(
                    fontSize: 11,
                    height: 1.8,
                    color: AppColors.inkQuiet,
                  ),
                  {
                    'terms': _linkSpan(ref.t('account_terms_link')),
                    'privacy': _linkSpan(ref.t('account_privacy_link')),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 実際に答えた内容を振り返って見せる。残せるものを見てから
/// 登録を促す流れにするため。
class _AnswerSummary extends ConsumerWidget {
  const _AnswerSummary({required this.answers});

  final OnboardingAnswers answers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chips = _buildChips(ref);
    if (chips.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgRaised,
        border: Border.all(color: AppColors.line),
        borderRadius: AppRadius.cardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            ref.t('account_summary_label'),
            style: AppTypography.mono(
              fontSize: AppTypography.labelSize,
              letterSpacing: AppTypography.labelLetterSpacing,
              color: AppColors.inkQuiet,
            ),
          ),
          Wrap(spacing: 6, runSpacing: 6, children: chips),
        ],
      ),
    );
  }

  List<Widget> _buildChips(WidgetRef ref) {
    final jp = AppTypography.jp(fontSize: 12, color: AppColors.ink);
    final mono = AppTypography.mono(fontSize: 12, color: AppColors.ink);
    final chips = <Widget>[];

    if (answers.level case final level?) {
      chips.add(
        _SummaryChip(
          span: TextSpan(
            style: jp,
            children: [
              TextSpan(text: ref.t(level.labelKey)),
              if (level.cefr case final cefr?)
                TextSpan(
                  text: ' $cefr',
                  style: AppTypography.mono(
                    fontSize: AppTypography.labelSize,
                    color: AppColors.inkQuiet,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    if (answers.target case final target?) {
      chips.add(
        _SummaryChip(
          span: TextSpan(
            text: ref.t(target.labelKey),
            style: target.usesLatinFace
                ? AppTypography.en(fontSize: 12, color: AppColors.ink)
                : jp,
          ),
        ),
      );
    }

    if (answers.purpose case final purpose?) {
      chips.add(
        _SummaryChip(
          span: TextSpan(text: ref.t(purpose.labelKey), style: jp),
        ),
      );
    }

    final examDate = answers.examDate;
    final score = answers.targetScore;
    if (examDate != null && score != null) {
      final date = switch (examDate) {
        ExamMonth(:final month) => TextSpan(
          text: ref.t('exam_date_month', params: {'month': '$month'}),
          style: mono,
        ),
        ExamUndecided() => TextSpan(
          text: ref.t('exam_date_undecided'),
          style: jp,
        ),
      };
      chips.add(
        _SummaryChip(
          span: _fillTemplate(ref.t('account_summary_exam'), jp, {
            'date': date,
            'score': TextSpan(text: score.value, style: mono),
          }),
        ),
      );
    }

    if (answers.dailyGoal case final goal?) {
      chips.add(
        _SummaryChip(
          span: _fillTemplate(ref.t('account_summary_daily'), jp, {
            'minutes': TextSpan(text: '${goal.minutes}', style: mono),
          }),
        ),
      );
    }

    return chips;
  }
}

/// 利用規約とプライバシーポリシーが遷移先だとわかるよう、リンク風に装飾する。
///
/// まだタップできない。URL が決まったら `TapGestureRecognizer` を付ける。
TextSpan _linkSpan(String text) => TextSpan(
  text: text,
  style: const TextStyle(
    color: AppColors.ink,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.ink,
  ),
);

final _placeholder = RegExp(r'\{(\w+)\}');

/// `{name}` 形式のテンプレートをスタイル付きの span で埋める。差し込む部分
/// （等幅の数字やリンク）は各自のスタイルを保ち、周りの文字は [baseStyle] を使う。
TextSpan _fillTemplate(
  String template,
  TextStyle baseStyle,
  Map<String, TextSpan> parts,
) {
  final children = <InlineSpan>[];
  var cursor = 0;
  for (final match in _placeholder.allMatches(template)) {
    if (match.start > cursor) {
      children.add(TextSpan(text: template.substring(cursor, match.start)));
    }
    final part = parts[match.group(1)];
    if (part != null) children.add(part);
    cursor = match.end;
  }
  if (cursor < template.length) {
    children.add(TextSpan(text: template.substring(cursor)));
  }
  return TextSpan(style: baseStyle, children: children);
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.span});

  final InlineSpan span;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgPage,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text.rich(span),
    );
  }
}
