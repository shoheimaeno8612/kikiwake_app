import 'package:flutter/material.dart';

/// 学習者が聞き取れるようになりたい場面（オンボーディングのステップ 3-A、
/// 一般英語の分岐）。
///
/// レコメンドに使うコンテンツのタグとは別の軸で、
/// 目的からタグの重みへの対応付けはバックエンドの責務。
enum LearningPurpose {
  daily(labelKey: 'purpose_daily', icon: Icons.chat_bubble_outline),
  travel(labelKey: 'purpose_travel', icon: Icons.flight_takeoff_outlined),
  business(labelKey: 'purpose_business', icon: Icons.work_outline),
  entertainment(
    labelKey: 'purpose_entertainment',
    icon: Icons.play_circle_outline,
  ),
  studyAbroad(labelKey: 'purpose_study_abroad', icon: Icons.public_outlined),
  hobby(labelKey: 'purpose_hobby', icon: Icons.menu_book_outlined);

  const LearningPurpose({required this.labelKey, required this.icon});

  final String labelKey;
  final IconData icon;
}
