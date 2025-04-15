import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_travels_3/config/constants.dart';
import 'package:safe_travels_3/config/theme.dart';
import 'package:safe_travels_3/data/septa_data.dart';
import 'package:safe_travels_3/models/review_model.dart';
import 'package:safe_travels_3/models/route_model.dart';
import 'package:safe_travels_3/models/station_model.dart';
import 'package:safe_travels_3/models/transit_line_model.dart';
import 'package:safe_travels_3/services/review_service.dart';
import 'package:safe_travels_3/widgets/custom_app_bar.dart';
import 'package:safe_travels_3/widgets/review_card.dart';
import 'package:safe_travels_3/widgets/star_rating.dart';

class ReviewsScreen extends StatefulWidget {
  final String startLocation;
  final String endLocation;
  final String transportationType;

  const ReviewsScreen({
    Key? key,
    required this.startLocation,
    required this.endLocation,
    required this.transportationType,
  }) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String? selectedAgeGroup;
  List<ReviewModel> reviews = [];
  RouteModel? route;
  bool _isLoading = true;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    print('ReviewsScreen initState');
    _loadRouteAndReviews();
  }

  @override
  void didUpdateWidget(ReviewsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload if any of the key parameters changed
    if (oldWidget.startLocation != widget.startLocation ||
        oldWidget.endLocation != widget.endLocation ||
        oldWidget.transportationType != widget.transportationType) {
      _loadRouteAndReviews();
    }
  }

  Future<void> _loadRouteAndReviews() async {
    print('_loadRouteAndReviews called');
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.transportationType == 'Regional Rail') {
        // Find transit lines that connect the selected stations
        final connectingLines = findConnectingLines(widget.startLocation, widget.endLocation);
        
        if (connectingLines.isNotEmpty) {
          // Use the first connecting line for now
          // In a real app, you might let the user choose which line
          final transitLine = connectingLines.first;
          
          // Get the direction of travel
          final direction = transitLine.getDirection(widget.startLocation, widget.endLocation);
          
          // Find or create a route for this transit line
          final existingRoute = mockRoutes.firstWhere(
            (r) => r.id == transitLine.lineId,
            orElse: () => RouteModel(
              id: transitLine.lineId,
              name: transitLine.name,
              startStationId: '0', // These IDs don't matter for display
              endStationId: '0',
              transportationType: widget.transportationType,
              averagePunctualityRating: 4.0,
              averageSafetyRating: 4.0,
              averageCleanlinessRating: 4.0,
              averageOverallRating: 4.0,
            ),
          );
          
          // Update the route with the selected stations and direction
          route = RouteModel(
            id: transitLine.lineId,
            name: "${transitLine.name} (${direction})",
            startStationId: existingRoute.startStationId,
            endStationId: existingRoute.endStationId,
            transportationType: existingRoute.transportationType,
            averagePunctualityRating: existingRoute.averagePunctualityRating,
            averageSafetyRating: existingRoute.averageSafetyRating,
            averageCleanlinessRating: existingRoute.averageCleanlinessRating,
            averageOverallRating: existingRoute.averageOverallRating,
          );
          
          // Get reviews for this route
          reviews = await ReviewService.getReviewsByRouteId(route!.id);
        } else {
          // No connecting lines found, show a message
          route = RouteModel(
            id: 'no-route',
            name: "No direct line found",
            startStationId: '0',
            endStationId: '0',
            transportationType: widget.transportationType,
            averagePunctualityRating: 0.0,
            averageSafetyRating: 0.0,
            averageCleanlinessRating: 0.0,
            averageOverallRating: 0.0,
          );
          reviews = [];
        }
      } else {
        // For other transportation types, use the existing behavior
        final typeRoutes = mockRoutes.where((r) =>
          r.transportationType == widget.transportationType
        ).toList();
        
        if (typeRoutes.isNotEmpty) {
          route = typeRoutes.first;
          
          final displayName = "${route!.name} (${widget.startLocation} to ${widget.endLocation})";
          final routeId = "${widget.transportationType}_${widget.startLocation}_${widget.endLocation}";
          
          route = RouteModel(
            id: routeId,
            name: displayName,
            startStationId: route!.startStationId,
            endStationId: route!.endStationId,
            transportationType: route!.transportationType,
            averagePunctualityRating: route!.averagePunctualityRating,
            averageSafetyRating: route!.averageSafetyRating,
            averageCleanlinessRating: route!.averageCleanlinessRating,
            averageOverallRating: route!.averageOverallRating,
          );
          
          // Get reviews for this route
          reviews = await ReviewService.getReviewsByRouteId(routeId);
        }
      }
    } catch (e) {
      // Handle error
      print('Error loading reviews: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<ReviewModel> get filteredReviews {
    if (selectedAgeGroup == null) {
      return reviews;
    }
    return reviews.where((review) => review.ageGroup == selectedAgeGroup).toList();
  }

  Future<void> _refreshReviews() async {
    if (_refreshing) return;
    
    setState(() {
      _refreshing = true;
    });
    
    try {
      await _loadRouteAndReviews();
    } finally {
      if (mounted) {
        setState(() {
          _refreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppConstants.filterAgeTitle,
        showBackButton: true,
        showEditButton: true,
        onEditPressed: () => _navigateToAddReview(),
        dropdown: _buildAgeFilterDropdown(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : route == null
              ? const Center(child: Text('No route found for the selected locations'))
              : Column(
                  children: [
                    _buildRouteHeader(),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshReviews,
                        child: filteredReviews.isEmpty
                            ? ListView(
                                children: const [
                                  SizedBox(height: 100),
                                  Center(
                                    child: Text(
                                      'No reviews available.\nPull down to refresh or tap + to add a review.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount: filteredReviews.length,
                                itemBuilder: (context, index) {
                                  final review = filteredReviews[index];
                                  return ReviewCard(
                                    review: review,
                                    onTap: () => _navigateToReviewDetail(review.id),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildRouteHeader() {
    return Container(
      padding: const EdgeInsets.all(24), // Increased padding
      color: AppTheme.lightGray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            route?.name ?? 'Route',
            style: const TextStyle(
              fontSize: AppTheme.headerFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Flexible(
                child: Text(
                  'Overall Rating: ',
                  style: TextStyle(
                    fontSize: AppTheme.bodyFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: StarRating(
                  rating: route?.averageOverallRating ?? 0,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.startLocation} to ${widget.endLocation}',
            style: const TextStyle(
              fontSize: AppTheme.bodyFontSize,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.transportationType,
            style: TextStyle(
              fontSize: AppTheme.labelFontSize,
              color: AppTheme.black.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeFilterDropdown() {
    return DropdownButton<String>(
      value: selectedAgeGroup,
      hint: const Text(
        'All Ages',
        style: TextStyle(color: AppTheme.white),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: AppTheme.white),
      style: const TextStyle(
        color: AppTheme.white,
        fontSize: AppTheme.bodyFontSize,
      ),
      underline: Container(),
      dropdownColor: AppTheme.primaryBlue,
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All Ages'),
        ),
        const DropdownMenuItem<String>(
          value: AppConstants.minor,
          child: Text(AppConstants.minor),
        ),
        const DropdownMenuItem<String>(
          value: AppConstants.adult,
          child: Text(AppConstants.adult),
        ),
      ],
      onChanged: (String? value) {
        setState(() {
          selectedAgeGroup = value;
        });
      },
    );
  }

  void _navigateToReviewDetail(String reviewId) {
    context.push('/review-detail/$reviewId');
  }

  void _navigateToAddReview() async {
    final result = await context.push<bool>(
      '/add-review?startLocation=${widget.startLocation}&endLocation=${widget.endLocation}&transportationType=${widget.transportationType}',
    );
    
    // If we got a true result, it means a review was added, so refresh
    if (result == true) {
      _refreshReviews();
    }
  }
}
