import 'package:app/core/l10n/app_strings.dart';
import 'package:app/core/router/router.dart';
import 'package:app/core/router/routes.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/domain/model/english_level.dart';
import 'package:app/domain/model/exam_date.dart';
import 'package:app/domain/model/onboarding_answers.dart';
import 'package:app/domain/model/study_target.dart';
import 'package:app/domain/model/target_score.dart';
import 'package:app/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppStrings strings;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    strings = await AppStrings.load();
  });

  /// スタブではなく実際のルーターを起動し、遷移と分岐をそのまま動かす。
  /// 画面サイズはアートボードに合わせて iPhone 390 x 844。
  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: [appStringsProvider.overrideWithValue(strings)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: container.read(routerProvider),
          theme: AppTheme.light,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  String t(String key, {Map<String, String>? params}) =>
      strings.t(key, params: params);

  /// 先に対象をスクロールして表示させる。844pt の画面では
  /// スコアのチップが画面外にあるため。
  Future<void> tapText(WidgetTester tester, String text) async {
    final finder = find.text(text);
    final scrollable = find.ancestor(
      of: finder,
      matching: find.byType(Scrollable),
    );
    if (scrollable.evaluate().isNotEmpty) {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
    }
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  bool nextIsEnabled(WidgetTester tester) {
    final button = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text(t('common_next')),
        matching: find.byType(FilledButton),
      ),
    );
    return button.onPressed != null;
  }

  testWidgets('launch lands on the intro, which has no back arrow', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text(t('intro_start')), findsOneWidget);
    expect(find.text(t('intro_tagline')), findsOneWidget);
    expect(find.byType(BackButton), findsNothing);
  });

  testWidgets('step 1 opens with intermediate chosen and next already live', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    await tapText(tester, t('intro_start'));

    expect(
      find.text(t('common_step', params: {'current': '1', 'total': '4'})),
      findsOneWidget,
    );
    expect(
      container.read(onboardingViewModelProvider).requireValue.answers.level,
      EnglishLevel.intermediate,
    );
    expect(nextIsEnabled(tester), isTrue);
  });

  testWidgets('tapping the chosen level clears it and disables next', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    await tapText(tester, t('intro_start'));

    await tapText(tester, t('level_intermediate'));

    expect(
      container.read(onboardingViewModelProvider).requireValue.answers.level,
      isNull,
    );
    expect(nextIsEnabled(tester), isFalse);
  });

  testWidgets('general English routes step 3 to the purpose question', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapText(tester, t('intro_start'));
    await tapText(tester, t('common_next'));

    expect(nextIsEnabled(tester), isFalse);
    await tapText(tester, t('target_general'));
    expect(nextIsEnabled(tester), isTrue);

    await tapText(tester, t('common_next'));

    expect(find.text(t('purpose_title')), findsOneWidget);
    expect(find.text(t('purpose_daily')), findsOneWidget);
  });

  testWidgets('TOEIC routes step 3 to the date and score question', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapText(tester, t('intro_start'));
    await tapText(tester, t('common_next'));
    await tapText(tester, t('target_toeic'));
    await tapText(tester, t('common_next'));

    expect(find.text(t('exam_title')), findsOneWidget);
    expect(find.text(t('exam_badge_toeic')), findsOneWidget);
    // TOEFL や IELTS ではなく TOEIC の刻み幅になっていること。
    expect(find.text('860'), findsOneWidget);
    expect(find.text('6.5'), findsNothing);
  });

  testWidgets('step 3-B needs both a date and a score before advancing', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapText(tester, t('intro_start'));
    await tapText(tester, t('common_next'));
    await tapText(tester, t('target_toeic'));
    await tapText(tester, t('common_next'));

    expect(nextIsEnabled(tester), isFalse);

    await tapText(tester, '800');
    expect(nextIsEnabled(tester), isFalse);

    await tapText(tester, t('exam_date_undecided'));
    expect(nextIsEnabled(tester), isTrue);
  });

  testWidgets('the score presets swap per exam while the layout holds', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapText(tester, t('intro_start'));
    await tapText(tester, t('common_next'));

    await tapText(tester, t('target_ielts'));
    await tapText(tester, t('common_next'));
    expect(find.text(t('exam_badge_ielts')), findsOneWidget);
    expect(find.text('6.5'), findsOneWidget);
    expect(find.text('860'), findsNothing);
  });

  testWidgets('switching target clears the previous branch answers', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    // 起動画面では誰も ViewModel を watch していないので、購読して保持しておく。
    final subscription = container.listen(
      onboardingViewModelProvider,
      (_, _) {},
    );
    addTearDown(subscription.close);
    final viewModel = container.read(onboardingViewModelProvider.notifier);
    OnboardingAnswers answers() =>
        container.read(onboardingViewModelProvider).requireValue.answers;

    await viewModel.selectTarget(StudyTarget.toeic);
    await viewModel.selectExamDate(const ExamDate.undecided());
    await viewModel.selectTargetScore(const TargetScore('800'));
    expect(answers().isExamAnswered, isTrue);

    await viewModel.selectTarget(StudyTarget.general);

    final cleared = answers();
    expect(cleared.examDate, isNull);
    expect(cleared.targetScore, isNull);
  });

  testWidgets('"other" opens the score sheet and the pick lands on the chip', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    await tapText(tester, t('intro_start'));
    await tapText(tester, t('common_next'));
    await tapText(tester, t('target_toeic'));
    await tapText(tester, t('common_next'));

    await tapText(tester, t('exam_score_other'));
    expect(find.text(t('exam_score_sheet_title')), findsOneWidget);

    // ピッカーの最初の行。あえてプリセットにない値を選ぶ。
    await tapText(tester, '300');
    expect(
      container
          .read(onboardingViewModelProvider)
          .requireValue
          .answers
          .targetScore,
      const TargetScore('300'),
    );
    expect(find.text('300'), findsOneWidget);
  });

  testWidgets('the account screen plays back the answers actually given', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapText(tester, t('intro_start'));
    await tapText(tester, t('common_next'));
    await tapText(tester, t('target_toeic'));
    await tapText(tester, t('common_next'));
    await tapText(tester, '800');
    await tapText(tester, t('exam_date_undecided'));
    await tapText(tester, t('common_next'));

    expect(
      find.text(t('common_step', params: {'current': '4', 'total': '4'})),
      findsOneWidget,
    );
    expect(nextIsEnabled(tester), isFalse);
    await tapText(tester, t('study_time_detail_min15'));
    expect(nextIsEnabled(tester), isTrue);
    await tapText(tester, t('common_next'));

    expect(find.text(t('account_title')), findsOneWidget);
    expect(find.text(t('account_summary_label')), findsOneWidget);
    // この画面にはステップ数を出さない。
    expect(find.textContaining('ステップ'), findsNothing);

    final summary = find.descendant(
      of: find.byType(Wrap),
      matching: find.byType(Text),
    );
    final rendered = tester
        .widgetList<Text>(summary)
        .map((text) => text.textSpan?.toPlainText() ?? text.data ?? '')
        .join(' | ');
    expect(rendered, contains(t('level_intermediate')));
    expect(rendered, contains('B1'));
    expect(rendered, contains(t('target_toeic')));
    expect(rendered, contains('800'));
    expect(rendered, contains('15'));
  });

  testWidgets('skipping registration leaves onboarding', (tester) async {
    final container = await pumpApp(tester);
    final router = container.read(routerProvider);
    router.go(Routes.onboardingAccount);
    await tester.pumpAndSettle();

    await tapText(tester, t('account_skip'));

    expect(find.text(t('main_placeholder')), findsOneWidget);
  });

  testWidgets('every step can be walked back', (tester) async {
    await pumpApp(tester);
    await tapText(tester, t('intro_start'));
    await tapText(tester, t('common_next'));
    await tapText(tester, t('target_general'));
    await tapText(tester, t('common_next'));

    expect(find.text(t('purpose_title')), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text(t('target_title')), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text(t('level_title')), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text(t('intro_start')), findsOneWidget);
  });
}
