import 'package:app/core/components/async_widget.dart';
import 'package:app/core/components/onboarding_scaffold.dart';
import 'package:app/core/components/question_header.dart';
import 'package:app/core/components/selection_card.dart';
import 'package:app/core/components/selection_check.dart';
import 'package:app/core/config/constants.dart';
import 'package:app/core/l10n/app_strings.dart';
import 'package:app/core/router/routes.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:app/domain/model/learning_purpose.dart';
import 'package:app/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// ステップ 3/4-A — 聞き取りたい場面（一般英語の分岐）。
class OnboardingPurposePage extends ConsumerWidget {
  const OnboardingPurposePage({super.key});

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
            params: {'current': '3', 'total': '$onboardingStepCount'},
          ),
          action: FilledButton(
            onPressed: answers.isPurposeAnswered
                ? () => context.push(Routes.onboardingStudyTime)
                : null,
            child: Text(ref.t('common_next')),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 18,
            children: [
              QuestionHeader(
                title: ref.t('purpose_title'),
                rationale: ref.t('purpose_description'),
              ),
              Column(
                spacing: _gap,
                children: LearningPurpose.values
                    .slices(2)
                    .map(
                      (row) => IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: _gap,
                          children: row
                              .map(
                                (purpose) => Expanded(
                                  child: _PurposeCard(
                                    purpose: purpose,
                                    isSelected: answers.purpose == purpose,
                                    onTap: () =>
                                        viewModel.selectPurpose(purpose),
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
        );
      },
    );
  }
}

class _PurposeCard extends ConsumerWidget {
  const _PurposeCard({
    required this.purpose,
    required this.isSelected,
    required this.onTap,
  });

  final LearningPurpose purpose;
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
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(purpose.icon, size: 20, color: AppColors.inkQuiet),
              SelectionCheck(isSelected: isSelected, size: 18),
            ],
          ),
          Text(
            ref.t(purpose.labelKey),
            style: AppTypography.jp(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              height: 1.55,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
