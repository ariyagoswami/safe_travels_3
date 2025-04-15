import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_travels_3/screens/add_review_screen.dart';
import 'package:safe_travels_3/screens/location_selection_screen.dart';
import 'package:safe_travels_3/screens/login_screen.dart';
import 'package:safe_travels_3/screens/register_screen.dart';
import 'package:safe_travels_3/screens/profile_screen.dart';
import 'package:safe_travels_3/screens/review_detail_screen.dart';
import 'package:safe_travels_3/screens/reviews_screen.dart';
import 'package:safe_travels_3/screens/transportation_selection_screen.dart';

class AppRouter {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  // Redirect logic
  static String? _redirectLogic(BuildContext context, GoRouterState state) {
    // If the user is not logged in and not on login or register page, redirect to login
    final isLoggingIn = state.matchedLocation == '/login' ||
                        state.matchedLocation == '/register';
    
    if (!isLoggedIn && !isLoggingIn) {
      return '/login';
    }
    
    // If the user is logged in and on login or register page, redirect to home
    if (isLoggedIn && isLoggingIn) {
      return '/';
    }
    
    // No redirection needed
    return null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: _redirectLogic,
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const TransportationSelectionScreen(),
      ),
      GoRoute(
        path: '/location-selection',
        name: 'locationSelection',
        builder: (context, state) {
          final isStarting = state.uri.queryParameters['isStarting'] == 'true';
          final transportationType = state.uri.queryParameters['transportationType'];
          return LocationSelectionScreen(
            isStarting: isStarting,
            transportationType: transportationType != null && transportationType.isNotEmpty
                ? transportationType
                : null,
          );
        },
      ),
      GoRoute(
        path: '/reviews',
        name: 'reviews',
        builder: (context, state) {
          final startLocation = state.uri.queryParameters['startLocation'] ?? '';
          final endLocation = state.uri.queryParameters['endLocation'] ?? '';
          final transportationType = state.uri.queryParameters['transportationType'] ?? '';
          return ReviewsScreen(
            startLocation: startLocation,
            endLocation: endLocation,
            transportationType: transportationType,
          );
        },
      ),
      GoRoute(
        path: '/review-detail/:reviewId',
        name: 'reviewDetail',
        builder: (context, state) {
          final reviewId = state.pathParameters['reviewId'] ?? '';
          return ReviewDetailScreen(reviewId: reviewId);
        },
      ),
      GoRoute(
        path: '/add-review',
        name: 'addReview',
        builder: (context, state) {
          final startLocation = state.uri.queryParameters['startLocation'] ?? '';
          final endLocation = state.uri.queryParameters['endLocation'] ?? '';
          final transportationType = state.uri.queryParameters['transportationType'] ?? '';
          final reviewId = state.uri.queryParameters['reviewId']; // null if adding new review
          return AddReviewScreen(
            startLocation: startLocation,
            endLocation: endLocation,
            transportationType: transportationType,
            reviewId: reviewId,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
