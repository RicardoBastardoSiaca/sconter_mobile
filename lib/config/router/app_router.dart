import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turnaround_mobile/features/auth/auth.dart';
import 'package:turnaround_mobile/features/turnarounds/presentation/screens/control_actividades_screen.dart';
import 'package:turnaround_mobile/features/turnarounds/presentation/screens/turnaround_main_screen.dart';

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
        path: '/control-actividades',
        builder: (context, state) => const ControlActividadesScreen(),
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