import 'package:flutter/material.dart';

/// Kikiwake のパレット。デザインシステムの `tokens/colors.css` から写した
/// Radix の 12 段階スケール。ライトモードのみで、オンボーディングも
/// ライト専用として定義されている。
///
/// 段階の役割は全ファミリー共通: 3 = 背景、6 = 枠線、9 = ソリッド、
/// 11 = 文字、12 = 色付きの小さなチップ上の文字。どの画面も約 95% は
/// Sand で構成し、ほかのファミリーは差分表示と正解状態でのみ使う。
abstract final class AppColors {
  // Sand — 面と文字。
  static const sand1 = Color(0xFFFDFDFC);
  static const sand2 = Color(0xFFF9F9F8);
  static const sand3 = Color(0xFFF1F0EF);
  static const sand4 = Color(0xFFE9E8E6);
  static const sand5 = Color(0xFFE2E1DE);
  static const sand6 = Color(0xFFDAD9D6);
  static const sand7 = Color(0xFFCFCECA);
  static const sand8 = Color(0xFFBCBBB5);
  static const sand9 = Color(0xFF8D8D86);
  static const sand10 = Color(0xFF82827C);
  static const sand11 = Color(0xFF63635E);
  static const sand12 = Color(0xFF21201C);

  // Iris — 唯一のアクセント。選択と正解にのみ使う。
  static const iris1 = Color(0xFFFDFDFF);
  static const iris2 = Color(0xFFF8F8FF);
  static const iris3 = Color(0xFFF0F1FE);
  static const iris4 = Color(0xFFE6E7FF);
  static const iris5 = Color(0xFFDADCFF);
  static const iris6 = Color(0xFFCBCDFF);
  static const iris7 = Color(0xFFB8BAF8);
  static const iris8 = Color(0xFF9B9EF0);
  static const iris9 = Color(0xFF5B5BD6);
  static const iris10 = Color(0xFF5151CD);
  static const iris11 = Color(0xFF5753C6);
  static const iris12 = Color(0xFF272962);

  // 差分表示用のファミリー。オンボーディングでは使わないが、ディクテーション画面が
  // 同じ定義を参照できるよう残している。
  static const tomato3 = Color(0xFFFEEBE7);
  static const tomato9 = Color(0xFFE54D2E);
  static const tomato11 = Color(0xFFD13415);

  static const amber3 = Color(0xFFFFF7C2);
  static const amber9 = Color(0xFFFFC53D);
  static const amber11 = Color(0xFFAB6400);

  static const cyan3 = Color(0xFFDEF7F9);
  static const cyan9 = Color(0xFF00A2C7);
  static const cyan11 = Color(0xFF107D98);

  // セマンティックな別名。画面から触る色はすべてここから取り、上の生のスケールを
  // 直接使わない（`tokens/semantic.css`）。
  static const bgPage = sand1;
  static const bgRaised = sand2;
  static const bgSunken = sand3;

  static const line = sand6;
  static const lineQuiet = sand4;

  static const ink = sand12;
  static const inkQuiet = sand11;

  /// 罫線・目盛り・プレースホルダー用。本文には使わない。
  static const inkGhost = sand9;

  static const accentBg = iris3;
  static const accentBorder = iris6;
  static const accentSolid = iris9;
  static const accentText = iris11;

  /// 未選択のチェックの丸の輪郭。
  static const checkOutline = sand7;
}
