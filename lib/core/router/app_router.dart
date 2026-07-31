import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_page.dart';

abstract final class AppRoute {
  static const home = 'home';
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
