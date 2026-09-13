/// 学習の目的（オンボーディングのステップ 2）。
///
/// ステップ 3 の分岐点も兼ねる: [general] は聞き取りたい場面を、
/// 試験の目的は受験日と目標スコアを尋ねる。
enum StudyTarget {
  general(
    labelKey: 'target_general',
    detailKey: 'target_general_detail',
    badgeKey: 'target_badge_general',
    scoreBadgeKey: null,
  ),
  toeic(
    labelKey: 'target_toeic',
    detailKey: 'target_toeic_detail',
    badgeKey: 'target_badge_exam',
    scoreBadgeKey: 'exam_badge_toeic',
  ),
  toefl(
    labelKey: 'target_toefl',
    detailKey: 'target_toefl_detail',
    badgeKey: 'target_badge_exam',
    scoreBadgeKey: 'exam_badge_toefl',
  ),
  ielts(
    labelKey: 'target_ielts',
    detailKey: 'target_ielts_detail',
    badgeKey: 'target_badge_exam',
    scoreBadgeKey: 'exam_badge_ielts',
  );

  const StudyTarget({
    required this.labelKey,
    required this.detailKey,
    required this.badgeKey,
    required this.scoreBadgeKey,
  });

  final String labelKey;
  final String detailKey;
  final String badgeKey;

  /// 目標スコアの見出しの横に添える補足（例: `TOEIC L&R`）。
  /// その画面に進まない [general] では null。
  final String? scoreBadgeKey;

  bool get isExam => this != general;

  /// 試験名は英文書体で組み、日本語のラベルはそうしない。
  bool get usesLatinFace => isExam;
}
