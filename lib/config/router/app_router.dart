import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turnaround_mobile/features/auth/auth.dart';
import 'package:turnaround_mobile/features/turnarounds/turnarounds.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.watch(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      //* Primara Pantalla Splash
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const TurnaroundMainScreen(),
      ),
      GoRoute(
        path: '/control-actividades/:id',
        builder: (context, state) => ControlActividadesScreen(
          // trcId: state.pathParameters['trcId']! as int,
          trcId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/image-fullscreen-carousel',
        builder: (context, state) => ImageFullscreenCarousel(),
      ),

      GoRoute(
        path: '/asignar-equipos-gse',
        builder: (context, state) => AsignarEquiposGseScreen(),
      ),
      GoRoute(
        path: '/asignar-personal',
        builder: (context, state) => AsignarPersonalScreen(),
      ),

      GoRoute(
        path: '/asignar-equipos-gse-control-actividades',
        builder: (context, state) => AsignarEquiposGseControlActividades(),
      ),
    ],

    // state.params ahora es state.pathParameters
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (authStatus == AuthStatus.checking) return '/splash';

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
        return null;
      }

      // if ( user.role == 'user' && isGoingTo == '/admin' ) return '/';

      return null;
    },
  );
});

// final appRouter = GoRouter(
//   initialLocation: '/splash',
//   routes: [
//     //* Primara Pantalla Splash 
//     GoRoute(
//       path: '/splash',
//       builder: (context, state) => const CheckAuthStatusScreen(),
//     ),
//     ///* Auth Routes
//     GoRoute(
//       path: '/login',
//       builder: (context, state) => const LoginScreen(),
//     ),
//     GoRoute(
//       path: '/register',
//       builder: (context, state) => const RegisterScreen(),
//     ),

//     ///* Product Routes
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const ProductsScreen(),
//     ),
//   ],
// );