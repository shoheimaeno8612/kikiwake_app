import 'package:app/domain/model/exam_date.dart';
import 'package:app/domain/model/onboarding_answers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';
part 'onboarding_state.g.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    required OnboardingAnswers answers,

    /// ステップ 3-B で出す月の候補。フロー開始時に固定し、途中で月が変わっても
    /// 並びがずれないようにする。
    required List<ExamDate> examDateOptions,
  }) = _OnboardingState;

  factory OnboardingState.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStateFromJson(json);
}
