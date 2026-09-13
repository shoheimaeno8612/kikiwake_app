import 'package:app/core/config/constants.dart';
import 'package:app/core/extensions/context_ext.dart';
import 'package:app/core/extensions/edge_insets_ext.dart';
import 'package:app/core/l10n/app_strings.dart';
import 'package:app/core/router/routes.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// イントロ／ウェルカム。
///
/// アンケートはまだ始まっていないので、ステップ数も戻る矢印も出さない。
/// アプリ名の意味を 1 行で伝える: 聞き取れなかった音が、
/// 聞き分けられる音になる。
class OnboardingIntroPage extends ConsumerWidget {
  const OnboardingIntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: context.safeAreaTop,
        ).withSafeBottom(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 34,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        // 直後にワードマークの文字があるので、読み上げからは外す。
                        Image.asset(
                          kikiwakeLogoAsset,
                          width: 80,
                          excludeFromSemantics: true,
                        ),
                        Text(
                          ref.t('intro_wordmark'),
                          style: AppTypography.en(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            height: 1,
                            letterSpacing: -0.88,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          ref.t('intro_reading'),
                          style: AppTypography.mono(
                            fontSize: AppTypography.labelSize,
                            letterSpacing: AppTypography.labelLetterSpacing,
                            color: AppColors.inkQuiet,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Text(
                          ref.t('intro_tagline'),
                          style: AppTypography.jp(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            height: 1.8,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          ref.t('intro_description'),
                          style: AppTypography.jp(
                            fontSize: 13.5,
                            height: 1.9,
                            color: AppColors.inkQuiet,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 10, 26, 6),
              child: FilledButton(
                onPressed: () => context.push(Routes.onboardingLevel),
                child: Text(ref.t('intro_start')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
