import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_travels_3/screens/add_review_screen.dart';
import 'package:safe_travels_3/screens/location_selection_screen.dart';
import 'package:safe_travels_3/screens/review_detail_screen.dart';
import 'package:safe_travels_3/screens/reviews_screen.dart';
import 'package:safe_travels_3/screens/transportation_selection_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
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
