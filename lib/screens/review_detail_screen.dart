import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_travels_3/config/constants.dart';
import 'package:safe_travels_3/config/theme.dart';
import 'package:safe_travels_3/models/review_model.dart';
import 'package:safe_travels_3/models/route_model.dart';
import 'package:safe_travels_3/models/station_model.dart';
import 'package:safe_travels_3/services/review_service.dart';
import 'package:safe_travels_3/widgets/custom_app_bar.dart';
import 'package:safe_travels_3/widgets/star_rating.dart';

class ReviewDetailScreen extends StatefulWidget {
  final String reviewId;

  const ReviewDetailScreen({
    Key? key,
    required this.reviewId,
  }) : super(key: key);

  @override
  State<ReviewDetailScreen> createState() => _ReviewDetailScreenState();
}

class _ReviewDetailScreenState extends State<ReviewDetailScreen> {
  ReviewModel? review;
  RouteModel? route;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviewAndRoute();
  }

  Future<void> _loadReviewAndRoute() async {
    try {
      // In a real app, we would fetch the review and route from a database
      review = await ReviewService.getReviewById(widget.reviewId);
      
      if (review != null) {
        // For now, we'll just use the mock data for routes
        route = getRouteById(review!.routeId);
        
        // If no route is found, create a simple one based on the review data
        if (route == null) {
          final parts = review!.routeName.split(':');
          if (parts.length > 1) {
            final transportationType = parts[0].trim();
            final locations = parts[1].trim().split(' to ');
            if (locations.length == 2) {
              route = RouteModel(
                id: review!.routeId,
                name: review!.routeName,
                startStationId: '0',
                endStationId: '0',
                transportationType: transportationType,
                averagePunctualityRating: review!.punctualityRating,
                averageSafetyRating: review!.safetyRating,
                averageCleanlinessRating: review!.cleanlinessRating,
                averageOverallRating: review!.overallRating,
              );
            }
          }
        }
      }
    } catch (e) {
      // Handle error
      print('Error loading review: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: AppConstants.reviewTitle,
          showBackButton: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (review == null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: AppConstants.reviewTitle,
          showBackButton: true,
        ),
        body: const Center(
          child: Text('Review not found'),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: AppConstants.reviewTitle,
        showBackButton: true,
        showEditButton: true,
        onEditPressed: () => _navigateToEditReview(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24), // Increased padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              route?.name ?? review!.routeName,
              style: const TextStyle(
                fontSize: AppTheme.headerFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              review!.username,
              style: const TextStyle(
                fontSize: AppTheme.bodyFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20), // Increased padding
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                review!.content,
                style: const TextStyle(
                  fontSize: AppTheme.bodyFontSize,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ratings',
              style: TextStyle(
                fontSize: AppTheme.bodyFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildRatingItem(AppConstants.punctuality, review!.punctualityRating),
            const SizedBox(height: 8),
            _buildRatingItem(AppConstants.safety, review!.safetyRating),
            const SizedBox(height: 8),
            _buildRatingItem(AppConstants.cleanliness, review!.cleanlinessRating),
            const SizedBox(height: 8),
            _buildRatingItem(AppConstants.overall, review!.overallRating),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Age Group: ${review!.ageGroup}',
                  style: TextStyle(
                    fontSize: AppTheme.labelFontSize,
                    color: AppTheme.black.withOpacity(0.6),
                  ),
                ),
                Text(
                  _formatDate(review!.createdAt),
                  style: TextStyle(
                    fontSize: AppTheme.labelFontSize,
                    color: AppTheme.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingItem(String category, double rating) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            category,
            style: const TextStyle(
              fontSize: AppTheme.bodyFontSize,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: StarRating(
            rating: rating,
            size: 20,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _navigateToEditReview() {
    if (route != null) {
      final routeParts = route!.name.split(':');
      if (routeParts.length > 1) {
        final locations = routeParts[1].trim().split(' to ');
        if (locations.length == 2) {
          final startLocation = locations[0];
          final endLocation = locations[1];
          
          context.push(
            '/add-review?startLocation=$startLocation&endLocation=$endLocation&transportationType=${route!.transportationType}&reviewId=${review!.id}',
          );
          return;
        }
      }
      
      // Fallback if we can't parse the route name
      context.push(
        '/add-review?startLocation=Unknown&endLocation=Unknown&transportationType=${route!.transportationType}&reviewId=${review!.id}',
      );
    }
  }
}
