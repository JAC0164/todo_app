import 'package:go_router/go_router.dart';
import 'package:todo_app/models/auth_data.dart';
import 'package:todo_app/pages/auth/auth_page.dart';
import 'package:todo_app/pages/home/home_page.dart';
import 'package:todo_app/pages/infos/infos_pages.dart';
import 'package:todo_app/pages/splash_page.dart';

// GoRouter configuration
GoRouter appRouter(AuthData? authState) {
  return GoRouter(
    redirect: (context, state) {
      if (authState?.showInfos == true) {
        return '/infos';
      }

      if (authState?.loading == true) {
        return '/splash';
      }

      if (authState?.user == null) {
        return '/auth';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: "/infos",
        builder: (context, state) => const InfosPages(),
      ),
    ],
  );
}
