import 'package:flutter/material.dart';

/// 角丸は 3 種類で足りる: 単語チップ、カード、再生コントロール
/// （`tokens/radius.css`）。影の仕組みはなく、階層は 1px の罫線と
/// 背景色の段階で表す。
abstract final class AppRadius {
  static const word = 2.0;
  static const chip = 4.0;
  static const card = 12.0;
  static const sheet = 16.0;

  static const cardBorder = BorderRadius.all(Radius.circular(card));
  static const chipBorder = BorderRadius.all(Radius.circular(chip));
  static const sheetBorder = BorderRadius.vertical(top: Radius.circular(sheet));
}
