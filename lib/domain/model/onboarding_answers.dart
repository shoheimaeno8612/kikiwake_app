import 'package:app/domain/model/daily_goal.dart';
import 'package:app/domain/model/english_level.dart';
import 'package:app/domain/model/exam_date.dart';
import 'package:app/domain/model/learning_purpose.dart';
import 'package:app/domain/model/study_target.dart';
import 'package:app/domain/model/target_score.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_answers.freezed.dart';
part 'onboarding_answers.g.dart';

/// オンボーディングで集める回答のすべて。
///
/// [level] は中級を初期値にして、自分の位置がわからない学習者が
/// 最初の画面で止まらないようにする。ほかの回答はすべて未回答から始まる。
@freezed
abstract class OnboardingAnswers with _$OnboardingAnswers {
  const factory OnboardingAnswers({
    @Default(EnglishLevel.intermediate) EnglishLevel? level,
    StudyTarget? target,
    LearningPurpose? purpose,
    ExamDate? examDate,
    TargetScore? targetScore,
    DailyGoal? dailyGoal,
  }) = _OnboardingAnswers;

  const OnboardingAnswers._();

  factory OnboardingAnswers.fromJson(Map<String, dynamic> json) =>
      _$OnboardingAnswersFromJson(json);

  bool get isLevelAnswered => level != null;

  bool get isTargetAnswered => target != null;

  bool get isPurposeAnswered => purpose != null;

  /// ステップ 3-B は日付とスコアの両方がそろって初めて進める。
  bool get isExamAnswered => examDate != null && targetScore != null;

  bool get isDailyGoalAnswered => dailyGoal != null;
}
