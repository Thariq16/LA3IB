import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/authentication/data/auth_repository.dart';
import '../features/authentication/presentation/user_profile_provider.dart';
import '../features/authentication/presentation/sign_in_screen.dart' show ModernSignInScreen;
import '../features/authentication/presentation/onboarding_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/profile/presentation/profile_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  
  // Watch the profile provider so router rebuilds when profile loads
  final userProfileAsync = ref.watch(currentUserProfileProvider);
  
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final user = authRepository.currentUser;
      final isLoggedIn = user != null;
      final path = state.uri.path;

      if (isLoggedIn) {
        final appUser = userProfileAsync.value;
        final isLoading = userProfileAsync.isLoading;
        final hasProfile = appUser != null;

        // If profile is still loading, keep user on current page
        // Don't redirect to onboarding until we know for sure there's no profile
        if (isLoading) {
          // If on login page and logged in but loading profile, stay on login
          // The router will re-evaluate once profile loads
          if (path == '/login') {
            return null; // Stay on login while loading
          }
          return null; // Stay on current page while loading
        }

        if (!hasProfile) {
          if (path != '/onboarding') {
            return '/onboarding';
          }
        } else {
          if (path == '/login' || path == '/onboarding') {
            return '/';
          }
        }
      } else {
        // Not logged in
        if (path != '/login') {
          return '/login';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      authRepository.authStateChanges(),
    ),
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const ModernSignInScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
