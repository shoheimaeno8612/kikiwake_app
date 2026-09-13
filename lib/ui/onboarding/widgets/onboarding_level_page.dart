import 'package:app/core/components/async_widget.dart';
import 'package:app/core/components/label_badge.dart';
import 'package:app/core/components/onboarding_scaffold.dart';
import 'package:app/core/components/question_header.dart';
import 'package:app/core/components/selection_card.dart';
import 'package:app/core/components/selection_check.dart';
import 'package:app/core/components/step_bars.dart';
import 'package:app/core/config/constants.dart';
import 'package:app/core/l10n/app_strings.dart';
import 'package:app/core/router/routes.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:app/domain/model/english_level.dart';
import 'package:app/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// ステップ 1/4 — 現在の英語レベル。
///
/// 自分の位置がわからない学習者がここで止まらないよう中級（B1）を選択済みにしており、
/// 「次へ」が最初から押せるのもそのため。
class OnboardingLevelPage extends ConsumerWidget {
  const OnboardingLevelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(onboardingViewModelProvider.notifier);

    return AsyncWidget(
      value: ref.watch(onboardingViewModelProvider),
      data: (state) {
        final answers = state.answers;

        return OnboardingScaffold(
          stepLabel: ref.t(
            'common_step',
            params: {'current': '1', 'total': '$onboardingStepCount'},
          ),
          action: FilledButton(
            onPressed: answers.isLevelAnswered
                ? () => context.push(Routes.onboardingTarget)
                : null,
            child: Text(ref.t('common_next')),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 18,
            children: [
              QuestionHeader(
                title: ref.t('level_title'),
                rationale: ref.t('level_description'),
              ),
              Column(
                spacing: 12,
                children: [
                  Column(
                    spacing: 14,
                    children: [
                      Column(
                        spacing: 8,
                        children: EnglishLevel.graded
                            .map(
                              (level) => _LevelCard(
                                level: level,
                                isSelected: answers.level == level,
                                onTap: () => viewModel.selectLevel(level),
                              ),
                            )
                            .toList(),
                      ),
                      // 段階のある選択肢と並べて順位づけせず、
                      // 区切って別扱いにする。
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Divider(height: 1),
                      ),
                    ],
                  ),
                  _UnsureCard(
                    isSelected: answers.level == EnglishLevel.unsure,
                    onTap: () => viewModel.selectLevel(EnglishLevel.unsure),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LevelCard extends ConsumerWidget {
  const _LevelCard({
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  final EnglishLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectionCard(
      isSelected: isSelected,
      onTap: onTap,
      child: Row(
        spacing: 14,
        children: [
          StepBars(
            filled: level.filledSteps,
            total: EnglishLevel.indicatorSteps,
            barWidth: 16,
            barHeight: 3,
            spacing: 2,
            axis: Axis.vertical,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Text(
                      ref.t(level.labelKey),
                      style: AppTypography.jp(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    if (level.cefr case final String cefr)
                      LabelBadge(
                        text: cefr,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                      ),
                  ],
                ),
                if (level.detailKey case final String detailKey)
                  Text(
                    ref.t(detailKey),
                    style: AppTypography.jp(
                      fontSize: 11.5,
                      height: 1.6,
                      color: AppColors.inkQuiet,
                    ),
                  ),
              ],
            ),
          ),
          SelectionCheck(isSelected: isSelected),
        ],
      ),
    );
  }
}

class _UnsureCard extends ConsumerWidget {
  const _UnsureCard({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectionCard(
      isSelected: isSelected,
      padding: EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: ref.t(EnglishLevel.unsure.labelKey)),
                  TextSpan(
                    text: ref.t('level_unsure_note'),
                    style: AppTypography.jp(
                      fontSize: 11,
                      color: AppColors.inkQuiet,
                    ),
                  ),
                ],
              ),
              style: AppTypography.jp(fontSize: 13, color: AppColors.inkQuiet),
            ),
          ),
          SelectionCheck(isSelected: isSelected, size: 18),
        ],
      ),
    );
  }
}
