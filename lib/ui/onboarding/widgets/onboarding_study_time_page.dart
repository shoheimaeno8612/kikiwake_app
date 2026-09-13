import 'package:app/core/components/async_widget.dart';
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
import 'package:app/domain/model/daily_goal.dart';
import 'package:app/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// ステップ 4/4 — 1 日に学習へ使える時間。
class OnboardingStudyTimePage extends ConsumerWidget {
  const OnboardingStudyTimePage({super.key});

  static const _gap = 8.0;

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
            params: {'current': '4', 'total': '$onboardingStepCount'},
          ),
          action: FilledButton(
            onPressed: answers.isDailyGoalAnswered
                ? () => context.push(Routes.onboardingAccount)
                : null,
            child: Text(ref.t('common_next')),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 18,
                children: [
                  QuestionHeader(
                    title: ref.t('study_time_title'),
                    rationale: ref.t('study_time_description'),
                  ),
                  Column(
                    spacing: _gap,
                    children: DailyGoal.values
                        .slices(2)
                        .map(
                          (row) => IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: _gap,
                              children: row
                                  .map(
                                    (goal) => Expanded(
                                      child: _GoalCard(
                                        goal: goal,
                                        isSelected: answers.dailyGoal == goal,
                                        onTap: () =>
                                            viewModel.selectDailyGoal(goal),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  ref.t('study_time_note'),
                  style: AppTypography.jp(
                    fontSize: 11.5,
                    height: 1.7,
                    color: AppColors.inkQuiet,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  final DailyGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectionCard(
      isSelected: isSelected,
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 24,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                spacing: 2,
                children: [
                  Text(
                    '${goal.minutes}',
                    style: AppTypography.mono(
                      fontSize: 30,
                      height: 1,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    ref.t(
                      goal.isOpenEnded
                          ? 'study_time_unit_plus'
                          : 'study_time_unit',
                    ),
                    style: AppTypography.jp(fontSize: 13, color: AppColors.ink),
                  ),
                ],
              ),
              SelectionCheck(isSelected: isSelected),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              StepBars(
                filled: goal.filledBars,
                total: DailyGoal.barCount,
                barWidth: 9,
                barHeight: 18,
                spacing: 4,
                axis: Axis.horizontal,
                emptyColor: AppColors.sand4,
              ),
              Text(
                ref.t(goal.detailKey),
                style: AppTypography.jp(
                  fontSize: 11.5,
                  height: 1.6,
                  color: AppColors.inkQuiet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
