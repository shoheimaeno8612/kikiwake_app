import 'package:app/domain/model/daily_goal.dart';
import 'package:app/domain/model/english_level.dart';
import 'package:app/domain/model/exam_date.dart';
import 'package:app/domain/model/learning_purpose.dart';
import 'package:app/domain/model/onboarding_answers.dart';
import 'package:app/domain/model/study_target.dart';
import 'package:app/domain/model/target_score.dart';
import 'package:app/ui/onboarding/view_models/onboarding_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_view_model.g.dart';

/// オンボーディングの回答をフローのあいだ保持し、全ステップで共有する。
///
/// 回答はメモリ上にだけ持つ。再起動後も残す必要が出たら、[build] と
/// [_updateAnswers] を唯一の接点としてリポジトリ
/// （`domain/repository` + `data/repository`）経由に切り替える。
///
/// 選択済みの選択肢をもう一度タップすると解除される（デザインの挙動に合わせている）。
/// そのため各コマンドは null 許容の値ではなく、タップされた値を受け取る。
@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  Future<OnboardingState> build() async {
    return OnboardingState(
      answers: const OnboardingAnswers(),
      examDateOptions: ExamDate.options(from: DateTime.now()),
    );
  }

  Future<void> selectLevel(EnglishLevel value) => _updateAnswers(
    (answers) => answers.copyWith(level: answers.level == value ? null : value),
  );

  /// 目的を変えると、どちらに変えてもステップ 3 の回答は無効になる。
  /// 2 つの分岐は別の質問をするので、前の分岐の回答を残してはいけない。
  Future<void> selectTarget(StudyTarget value) => _updateAnswers(
    (answers) => answers.copyWith(
      target: answers.target == value ? null : value,
      purpose: null,
      examDate: null,
      targetScore: null,
    ),
  );

  Future<void> selectPurpose(LearningPurpose value) => _updateAnswers(
    (answers) =>
        answers.copyWith(purpose: answers.purpose == value ? null : value),
  );

  Future<void> selectExamDate(ExamDate value) => _updateAnswers(
    (answers) =>
        answers.copyWith(examDate: answers.examDate == value ? null : value),
  );

  Future<void> selectTargetScore(TargetScore value) => _updateAnswers(
    (answers) => answers.copyWith(
      targetScore: answers.targetScore == value ? null : value,
    ),
  );

  /// 「その他」のシートから選んだ値。トグルではなく常に設定する。
  Future<void> setTargetScore(TargetScore value) =>
      _updateAnswers((answers) => answers.copyWith(targetScore: value));

  Future<void> selectDailyGoal(DailyGoal value) => _updateAnswers(
    (answers) =>
        answers.copyWith(dailyGoal: answers.dailyGoal == value ? null : value),
  );

  Future<void> _updateAnswers(
    OnboardingAnswers Function(OnboardingAnswers answers) update,
  ) async {
    final current = await future;
    state = AsyncData(current.copyWith(answers: update(current.answers)));
  }
}
