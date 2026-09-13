import 'package:app/core/router/routes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'launch_state.freezed.dart';
part 'launch_state.g.dart';

/// 起動後の遷移先。
enum LaunchDestination {
  onboarding(route: Routes.onboarding),
  main(route: Routes.main);

  const LaunchDestination({required this.route});

  final String route;
}

@freezed
abstract class LaunchState with _$LaunchState {
  const factory LaunchState({required LaunchDestination destination}) =
      _LaunchState;

  factory LaunchState.fromJson(Map<String, dynamic> json) =>
      _$LaunchStateFromJson(json);
}
