/// 自己申告の英語レベル（オンボーディングのステップ 1）。
///
/// 平易な日本語の表現を主にし、CEFR の記号は小さな補足として添える。
/// C2 はあえて含めない。この段階を増やす想定はない。
enum EnglishLevel {
  beginner(
    labelKey: 'level_beginner',
    detailKey: 'level_beginner_detail',
    cefr: 'A1',
    filledSteps: 1,
  ),
  elementary(
    labelKey: 'level_elementary',
    detailKey: 'level_elementary_detail',
    cefr: 'A2',
    filledSteps: 2,
  ),
  intermediate(
    labelKey: 'level_intermediate',
    detailKey: 'level_intermediate_detail',
    cefr: 'B1',
    filledSteps: 3,
  ),
  upperIntermediate(
    labelKey: 'level_upper_intermediate',
    detailKey: 'level_upper_intermediate_detail',
    cefr: 'B2',
    filledSteps: 4,
  ),
  advanced(
    labelKey: 'level_advanced',
    detailKey: 'level_advanced_detail',
    cefr: 'C1',
    filledSteps: 5,
  ),

  /// 段階のある選択肢とは見た目で分け、自分の位置がわからない人でも
  /// ここで止まらないようにする。
  unsure(labelKey: 'level_unsure', detailKey: null, cefr: null, filledSteps: 0);

  const EnglishLevel({
    required this.labelKey,
    required this.detailKey,
    required this.cefr,
    required this.filledSteps,
  });

  final String labelKey;
  final String? detailKey;
  final String? cefr;

  /// 5 本のインジケーターのうち塗る本数。
  final int filledSteps;

  /// 段階のある 5 つの選択肢を順に返す。[unsure] は含まない。
  static List<EnglishLevel> get graded =>
      values.where((level) => level != unsure).toList();

  static const indicatorSteps = 5;
}
