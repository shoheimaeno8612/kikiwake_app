import 'package:app/core/router/routes.dart';
import 'package:app/ui/launch/widgets/launch_page.dart';
import 'package:app/ui/main/widgets/main_page.dart';
import 'package:app/ui/onboarding/widgets/onboarding_account_page.dart';
import 'package:app/ui/onboarding/widgets/onboarding_exam_page.dart';
import 'package:app/ui/onboarding/widgets/onboarding_intro_page.dart';
import 'package:app/ui/onboarding/widgets/onboarding_level_page.dart';
import 'package:app/ui/onboarding/widgets/onboarding_purpose_page.dart';
import 'package:app/ui/onboarding/widgets/onboarding_study_time_page.dart';
import 'package:app/ui/onboarding/widgets/onboarding_target_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: Routes.launch,
        builder: (context, state) => const LaunchPage(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingIntroPage(),
      ),
      GoRoute(
        path: Routes.onboardingLevel,
        builder: (context, state) => const OnboardingLevelPage(),
      ),
      GoRoute(
        path: Routes.onboardingTarget,
        builder: (context, state) => const OnboardingTargetPage(),
      ),
      GoRoute(
        path: Routes.onboardingPurpose,
        builder: (context, state) => const OnboardingPurposePage(),
      ),
      GoRoute(
        path: Routes.onboardingExam,
        builder: (context, state) => const OnboardingExamPage(),
      ),
      GoRoute(
        path: Routes.onboardingStudyTime,
        builder: (context, state) => const OnboardingStudyTimePage(),
      ),
      GoRoute(
        path: Routes.onboardingAccount,
        builder: (context, state) => const OnboardingAccountPage(),
      ),
      GoRoute(path: Routes.main, builder: (context, state) => const MainPage()),
    ],
  );
});
