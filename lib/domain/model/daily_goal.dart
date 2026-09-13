/// 1 日に学習へ使える時間（オンボーディングのステップ 4）。
///
/// コンテンツ 1 本は約 1 分の音声。すべての単語が聞き取れるまで
/// 繰り返し聞くので、1 本あたり約 10 分かかる。
enum DailyGoal {
  min5(minutes: 5, filledBars: 1, detailKey: 'study_time_detail_min5'),
  min15(minutes: 15, filledBars: 2, detailKey: 'study_time_detail_min15'),
  min30(minutes: 30, filledBars: 3, detailKey: 'study_time_detail_min30'),
  min60(
    minutes: 60,
    filledBars: 6,
    detailKey: 'study_time_detail_min60',
    isOpenEnded: true,
  );

  const DailyGoal({
    required this.minutes,
    required this.filledBars,
    required this.detailKey,
    this.isOpenEnded = false,
  });

  final int minutes;

  /// 6 本のバーのうち塗る本数。
  final int filledBars;
  final String detailKey;

  /// `60分` ではなく `60分〜` と表示する。
  final bool isOpenEnded;

  static const barCount = 6;
}
