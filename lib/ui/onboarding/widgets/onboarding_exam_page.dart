import 'package:app/core/components/async_widget.dart';
import 'package:app/core/components/onboarding_scaffold.dart';
import 'package:app/core/components/question_header.dart';
import 'package:app/core/config/constants.dart';
import 'package:app/core/l10n/app_strings.dart';
import 'package:app/core/router/routes.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:app/domain/model/exam_date.dart';
import 'package:app/domain/model/study_target.dart';
import 'package:app/domain/model/target_score.dart';
import 'package:app/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:app/ui/onboarding/widgets/target_score_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// ステップ 3/4-B — 受験日と目標スコア（TOEIC / TOEFL / IELTS の分岐）。
///
/// 3 つの試験で 1 つのレイアウトを使い、変わるのはスコアのチップと
/// 見出し横の補足だけ。日付の並びの末尾には必ず「まだ決めていない」を置き、
/// 未定の学習者がフローから外れないようにする。
class OnboardingExamPage extends ConsumerWidget {
  const OnboardingExamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncWidget(
      value: ref.watch(onboardingViewModelProvider),
      data: (state) {
        final answers = state.answers;

        return OnboardingScaffold(
          stepLabel: ref.t(
            'common_step',
            params: {'current': '3', 'total': '$onboardingStepCount'},
          ),
          action: FilledButton(
            onPressed: answers.isExamAnswered
                ? () => context.push(Routes.onboardingStudyTime)
                : null,
            child: Text(ref.t('common_next')),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 22,
                children: [
                  QuestionHeader(
                    title: ref.t('exam_title'),
                    rationale: ref.t('exam_description'),
                  ),
                  _ExamDateSection(
                    options: state.examDateOptions,
                    selected: answers.examDate,
                  ),
                ],
              ),
              const Divider(height: 1),
              _TargetScoreSection(
                target: answers.target ?? StudyTarget.toeic,
                selected: answers.targetScore,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExamDateSection extends ConsumerWidget {
  const _ExamDateSection({required this.options, required this.selected});

  final List<ExamDate> options;
  final ExamDate? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(onboardingViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        _SectionHeading(label: ref.t('exam_date_label'), aide: _yearRange(ref)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map(
                (option) => ChoiceChip(
                  selected: selected == option,
                  onSelected: (_) => viewModel.selectExamDate(option),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: switch (option) {
                    ExamMonth(:final month) => Text(
                      ref.t('exam_date_month', params: {'month': '$month'}),
                      strutStyle: _dateStrut,
                      style: AppTypography.mono(fontSize: 14),
                    ),
                    ExamUndecided() => Text(
                      ref.t('exam_date_undecided'),
                      strutStyle: _dateStrut,
                      style: AppTypography.jp(fontSize: 13),
                    ),
                  },
                ),
              )
              .toList(),
        ),
        Text(
          ref.t('exam_date_note'),
          style: AppTypography.jp(
            fontSize: 11,
            height: 1.7,
            color: AppColors.inkQuiet,
          ),
        ),
      ],
    );
  }

  /// 候補の月が年をまたぐときは `2026 — 2027`、
  /// またがないときは年だけを返す。
  String _yearRange(WidgetRef ref) {
    final months = options.whereType<ExamMonth>();
    final start = months.first.year;
    final end = months.last.year;
    if (start == end) return '$start';
    return ref.t('exam_date_range', params: {'start': '$start', 'end': '$end'});
  }
}

class _TargetScoreSection extends ConsumerWidget {
  const _TargetScoreSection({required this.target, required this.selected});

  final StudyTarget target;
  final TargetScore? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(onboardingViewModelProvider.notifier);
    final presets = TargetScore.presetsFor(target);
    final custom = selected != null && !presets.contains(selected)
        ? selected
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            _SectionHeading(
              label: ref.t('exam_score_label'),
              aide: ref.t(target.scoreBadgeKey!),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...presets.map(
                  (score) => ChoiceChip(
                    selected: selected == score,
                    onSelected: (_) => viewModel.selectTargetScore(score),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: _ScoreLabel(score: score),
                  ),
                ),
                ChoiceChip(
                  selected: custom != null,
                  onSelected: (_) => _openPicker(context, ref),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // 控えめな文字色にして、プリセットの 1 つではなく
                  // 逃げ道として読めるようにする。
                  labelStyle: TextStyle(
                    color: WidgetStateColor.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? AppColors.accentText
                          : AppColors.inkQuiet,
                    ),
                  ),
                  label: Text(
                    custom?.value ?? ref.t('exam_score_other'),
                    strutStyle: _scoreStrut,
                    style: custom != null
                        ? AppTypography.mono(fontSize: 17)
                        : AppTypography.jp(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          ref.t('exam_score_note'),
          style: AppTypography.jp(
            fontSize: 11,
            height: 1.7,
            color: AppColors.inkQuiet,
          ),
        ),
      ],
    );
  }

  Future<void> _openPicker(BuildContext context, WidgetRef ref) async {
    final picked = await showTargetScoreSheet(context: context, target: target);
    if (picked == null) return;
    await ref.read(onboardingViewModelProvider.notifier).setTargetScore(picked);
  }
}

/// 月と「まだ決めていない」のラベルで行の高さをそろえ、
/// 日付のチップを同じ高さにする。
const _dateStrut = StrutStyle(
  fontSize: 14,
  height: 1.3,
  forceStrutHeight: true,
);

/// スコアのチップのラベルはすべて同じ行の高さにそろえ、日本語の「その他」と
/// 等幅の数字でチップの高さが変わらないようにする。
const _scoreStrut = StrutStyle(
  fontSize: 17,
  height: 1.3,
  forceStrutHeight: true,
);

/// 数字は等幅書体で組み、「以上」の接尾辞は日本語のままにする。
class _ScoreLabel extends ConsumerWidget {
  const _ScoreLabel({required this.score});

  final TargetScore score;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = Text(
      score.value,
      strutStyle: _scoreStrut,
      style: AppTypography.mono(fontSize: 17),
    );
    if (!score.isOrAbove) return value;

    return Row(
      mainAxisSize: MainAxisSize.min,
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      spacing: 4,
      children: [
        value,
        Text(
          ref.t('exam_score_suffix_plus'),
          strutStyle: _scoreStrut,
          style: AppTypography.jp(fontSize: 12),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.label, required this.aide});

  final String label;
  final String aide;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.jp(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        Text(
          aide,
          style: AppTypography.mono(
            fontSize: AppTypography.labelSize,
            letterSpacing: AppTypography.labelLetterSpacing,
            color: AppColors.inkQuiet,
          ),
        ),
      ],
    );
  }
}
