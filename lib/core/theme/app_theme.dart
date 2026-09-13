import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// デザインシステムのトークンから組み立てた、ライト専用のテーマ。
///
/// できるだけコンポーネントテーマ側にスタイルを持たせ、
/// 各画面は素の Flutter ウィジェットに近い書き方で済むようにする。
abstract final class AppTheme {
  static const _colorScheme = ColorScheme.light(
    primary: AppColors.accentSolid,
    onPrimary: AppColors.sand1,
    secondary: AppColors.accentText,
    onSecondary: AppColors.sand1,
    surface: AppColors.bgPage,
    onSurface: AppColors.ink,
    surfaceContainerHighest: AppColors.bgSunken,
    error: AppColors.tomato9,
    onError: AppColors.sand1,
    outline: AppColors.line,
    outlineVariant: AppColors.lineQuiet,
  );

  /// ボタンの高さは最小サイズではなく padding で確保する。
  static const _buttonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
  );

  static ThemeData get light {
    final textTheme = GoogleFonts.notoSansJpTextTheme(
      ThemeData.light().textTheme,
    ).apply(bodyColor: AppColors.ink, displayColor: AppColors.ink);

    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.bgPage,
      // デザイン全体を通して影の仕組みは使わない。
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgPage,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.inkQuiet,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.jp(
          fontSize: AppTypography.metaSize,
          color: AppColors.inkQuiet,
        ),
        iconTheme: const IconThemeData(color: AppColors.inkQuiet, size: 20),
      ),
      // ChoiceChip も `SelectionSurface` と同じ選択表現にそろえる:
      // アクセントの地色・枠線・文字色が同時に変わり、チェックマークは出さない。
      chipTheme: ChipThemeData(
        color: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.accentBg
              : AppColors.bgRaised,
        ),
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(
            color: states.contains(WidgetState.selected)
                ? AppColors.accentBorder
                : AppColors.line,
          ),
        ),
        labelStyle: TextStyle(
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.accentText
                : AppColors.ink,
          ),
        ),
        shape: const StadiumBorder(),
        showCheckmark: false,
        elevation: 0,
        pressElevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelPadding: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lineQuiet,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.bgPage,
          disabledBackgroundColor: AppColors.sand4,
          disabledForegroundColor: AppColors.inkGhost,
          elevation: 0,
          shape: const StadiumBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
          padding: _buttonPadding,
          textStyle: AppTypography.jp(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.bgRaised,
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.line),
          shape: const StadiumBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
          padding: _buttonPadding,
          textStyle: AppTypography.jp(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.inkQuiet,
          shape: const StadiumBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
          padding: _buttonPadding,
          textStyle: AppTypography.jp(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bgPage,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: AppColors.sand7,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetBorder),
      ),
    );
  }
}
