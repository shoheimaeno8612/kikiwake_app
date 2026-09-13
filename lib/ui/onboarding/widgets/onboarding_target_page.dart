import 'package:app/core/components/async_widget.dart';
import 'package:app/core/components/label_badge.dart';
import 'package:app/core/components/onboarding_scaffold.dart';
import 'package:app/core/components/question_header.dart';
import 'package:app/core/components/selection_card.dart';
import 'package:app/core/components/selection_check.dart';
import 'package:app/core/config/constants.dart';
import 'package:app/core/l10n/app_strings.dart';
import 'package:app/core/router/routes.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:app/domain/model/study_target.dart';
import 'package:app/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// ステップ 2/4 — 学習の目的。
///
/// この選択でステップ 3 の質問が決まるので、ステップ 3 で同じことは聞かない。
class OnboardingTargetPage extends ConsumerWidget {
  const OnboardingTargetPage({super.key});

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
            params: {'current': '2', 'total': '$onboardingStepCount'},
          ),
          action: FilledButton(
            onPressed: answers.target == null
                ? null
                : () => context.push(
                    answers.target!.isExam
                        ? Routes.onboardingExam
                        : Routes.onboardingPurpose,
                  ),
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
                    title: ref.t('target_title'),
                    rationale: ref.t('target_description'),
                  ),
                  Column(
                    spacing: _gap,
                    children: StudyTarget.values
                        .slices(2)
                        .map(
                          (row) => IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: _gap,
                              children: row
                                  .map(
                                    (target) => Expanded(
                                      child: _TargetCard(
                                        target: target,
                                        isSelected: answers.target == target,
                                        onTap: () =>
                                            viewModel.selectTarget(target),
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
                  ref.t('target_note'),
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

class _TargetCard extends ConsumerWidget {
  const _TargetCard({
    required this.target,
    required this.isSelected,
    required this.onTap,
  });

  final StudyTarget target;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.t(target.labelKey);

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
              LabelBadge(text: ref.t(target.badgeKey)),
              SelectionCheck(isSelected: isSelected),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Text(
                name,
                style: target.usesLatinFace
                    ? AppTypography.en(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.22,
                        color: AppColors.ink,
                      )
                    : AppTypography.jp(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
              ),
              Text(
                ref.t(target.detailKey),
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
