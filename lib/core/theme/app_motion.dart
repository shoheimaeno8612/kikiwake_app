import 'package:flutter/animation.dart';

/// 既定は 120ms のフェードと 2px の移動（`tokens/motion.css`）。
/// オンボーディングでは何も弾ませない。スプリングはディクテーション画面で
/// 単語の正解が確定したとき専用。
abstract final class AppMotion {
  static const durQuiet = Duration(milliseconds: 120);
  static const durSheet = Duration(milliseconds: 200);
  static const easeQuiet = Cubic(0.2, 0, 0, 1);
}
