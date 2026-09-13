import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// デザインシステムの `tokens/fonts.css` で定義された 3 つの書体。
///
/// フォントは初回利用時に `google_fonts` が取得して端末にキャッシュし、
/// 2 回目以降の起動ではネットワークではなくキャッシュから読む。
abstract final class AppTypography {
  /// 日本語の UI 文言。アプリ内のほぼすべてのラベルに使う。
  static TextStyle jp({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    Color? color,
    double? letterSpacing,
  }) => GoogleFonts.notoSansJp(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    color: color,
    letterSpacing: letterSpacing,
  );

  /// 英文の本文とワードマーク。Braille Institute の高判読性デザインで、
  /// I / l / 1 や 0 / O をグリフの段階で描き分けている。
  static TextStyle en({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    Color? color,
    double? letterSpacing,
  }) => GoogleFonts.atkinsonHyperlegibleNext(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    color: color,
    letterSpacing: letterSpacing,
  );

  /// カウンター、スコア、タイムコード、識別子。
  static TextStyle mono({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    Color? color,
    double? letterSpacing,
  }) => GoogleFonts.ibmPlexMono(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    color: color,
    letterSpacing: letterSpacing,
  );

  /// `tokens/typography.css` の役割のうち、オンボーディングで使うもの。
  static const displayJpSize = 22.0;
  static const displayJpHeight = 1.4;
  static const bodyJpSize = 14.0;
  static const bodyJpHeight = 1.8;
  static const metaSize = 12.0;
  static const labelSize = 10.0;
  static const labelLetterSpacing = 1.0; // 10px における 0.1em
}
