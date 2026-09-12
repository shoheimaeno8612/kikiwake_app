import 'package:app/core/router/routes.dart';
import 'package:app/ui/launch/widgets/launch_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(routes: [
    GoRoute(
      path: Routes.launch,
      builder: (context, state) => LaunchPage(),
    ),
  ]);
});
