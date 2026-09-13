import 'package:app/domain/model/study_target.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'target_score.freezed.dart';
part 'target_score.g.dart';

/// 試験の目的ごとの目標スコア（オンボーディングのステップ 3-B）。
///
/// プリセットは試験ごとに違うがレイアウトは変わらない。TOEIC・TOEFL・IELTS で
/// 変わるのはチップのラベルと刻み幅だけ。
@freezed
abstract class TargetScore with _$TargetScore {
  const factory TargetScore(
    /// IELTS のバンドは 0.5 刻み（`6.5`）で、TOEIC と TOEFL は整数なので、
    /// 文字列で持つ。
    String value, {

    /// 「以上」を付けて表示する（例: `900以上`）。
    @Default(false) bool isOrAbove,
  }) = _TargetScore;

  factory TargetScore.fromJson(Map<String, dynamic> json) =>
      _$TargetScoreFromJson(json);

  /// 「その他」でピッカーを開く前に、画面上に並べるチップ。
  static List<TargetScore> presetsFor(StudyTarget target) => switch (target) {
    StudyTarget.toeic => const [
      TargetScore('500'),
      TargetScore('600'),
      TargetScore('700'),
      TargetScore('800'),
      TargetScore('860'),
      TargetScore('900', isOrAbove: true),
    ],
    StudyTarget.toefl => const [
      TargetScore('60'),
      TargetScore('70'),
      TargetScore('80'),
      TargetScore('90'),
      TargetScore('100', isOrAbove: true),
    ],
    StudyTarget.ielts => const [
      TargetScore('5.5'),
      TargetScore('6.0'),
      TargetScore('6.5'),
      TargetScore('7.0'),
      TargetScore('7.5', isOrAbove: true),
    ],
    StudyTarget.general => const [],
  };

  /// 「その他」のシートで選べる、より広い範囲。
  static List<TargetScore> pickerOptionsFor(StudyTarget target) =>
      switch (target) {
        // TOEIC L&R は 10〜990 の 5 点刻み。
        StudyTarget.toeic => [
          for (var score = 300; score <= 990; score += 5) TargetScore('$score'),
        ],
        StudyTarget.toefl => [
          for (var score = 40; score <= 120; score++) TargetScore('$score'),
        ],
        StudyTarget.ielts => [
          for (var half = 8; half <= 18; half++)
            TargetScore((half / 2).toStringAsFixed(1)),
        ],
        StudyTarget.general => const [],
      };
}
