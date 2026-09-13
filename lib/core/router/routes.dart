final class Routes {
  Routes._();

  static const launch = '/';

  /// イントロ／ウェルカム。以下のステップは学習者向けに 1〜4 と番号を振る。
  /// イントロとアカウント画面はその数に含まない。
  static const onboarding = '/onboarding';
  static const onboardingLevel = '/onboarding/level';
  static const onboardingTarget = '/onboarding/target';

  /// ステップ 3、一般英語の分岐。
  static const onboardingPurpose = '/onboarding/purpose';

  /// ステップ 3、TOEIC / TOEFL / IELTS の分岐。
  static const onboardingExam = '/onboarding/exam';

  static const onboardingStudyTime = '/onboarding/study-time';
  static const onboardingAccount = '/onboarding/account';

  /// オンボーディング完了後の遷移先。
  static const main = '/main';
}
