import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_date.freezed.dart';
part 'exam_date.g.dart';

/// 学習者が目指す受験回（オンボーディングのステップ 3-B）。
///
/// 一覧は固定ではなく現在の日付から生成し、末尾には必ず
/// [ExamDate.undecided] を置いて、未定の学習者が先へ進めなくならないようにする。
@freezed
sealed class ExamDate with _$ExamDate {
  const factory ExamDate.month({required int year, required int month}) =
      ExamMonth;

  const factory ExamDate.undecided() = ExamUndecided;

  const ExamDate._();

  factory ExamDate.fromJson(Map<String, dynamic> json) =>
      _$ExamDateFromJson(json);

  bool get isUndecided => this is ExamUndecided;

  /// [from] の翌月から始まる [count] か月分。
  static List<ExamMonth> upcomingMonths({
    required DateTime from,
    int count = 5,
  }) {
    return List.generate(count, (index) {
      final shifted = DateTime(from.year, from.month + index + 1);
      return ExamMonth(year: shifted.year, month: shifted.month);
    });
  }

  /// チップの一覧全体: 直近の月と、逃げ道としての「未定」。
  static List<ExamDate> options({required DateTime from, int count = 5}) => [
    ...upcomingMonths(from: from, count: count),
    const ExamDate.undecided(),
  ];
}
