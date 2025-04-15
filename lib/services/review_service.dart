import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safe_travels_3/models/review_model.dart';

class ReviewService {
  static const String _reviewsKey = 'user_reviews';
  static List<ReviewModel> _cachedReviews = [];
  static bool _initialized = false;

  // Initialize the service by loading reviews from storage
  static Future<void> initialize() async {
    if (_initialized) return;
    
    await _loadReviews();
    _initialized = true;
  }

  // Load reviews from SharedPreferences
  static Future<void> _loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final reviewsJson = prefs.getStringList(_reviewsKey) ?? [];
    
    _cachedReviews = reviewsJson
        .map((json) => ReviewModel.fromJson(jsonDecode(json)))
        .toList();
  }

  // Save reviews to SharedPreferences
  static Future<void> _saveReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final reviewsJson = _cachedReviews
        .map((review) => jsonEncode(review.toJson()))
        .toList();
    
    print('Saving ${reviewsJson.length} reviews to SharedPreferences');
    print('Reviews: $reviewsJson');
    
    await prefs.setStringList(_reviewsKey, reviewsJson);
  }

  // Get all reviews
  static Future<List<ReviewModel>> getAllReviews() async {
    await initialize();
    return List.from(_cachedReviews);
  }

  // Get reviews by route ID
  static Future<List<ReviewModel>> getReviewsByRouteId(String routeId) async {
    await initialize();
    final result = _cachedReviews
        .where((review) => review.routeId == routeId)
        .toList();
    
    print('Getting reviews for route $routeId: found ${result.length} reviews');
    return result;
  }

  // Get reviews by user ID
  static Future<List<ReviewModel>> getReviewsByUserId(String userId) async {
    await initialize();
    return _cachedReviews
        .where((review) => review.userId == userId)
        .toList();
  }

  // Get reviews by age group
  static Future<List<ReviewModel>> getReviewsByAgeGroup(String ageGroup) async {
    await initialize();
    return _cachedReviews
        .where((review) => review.ageGroup == ageGroup)
        .toList();
  }

  // Get review by ID
  static Future<ReviewModel?> getReviewById(String id) async {
    await initialize();
    try {
      return _cachedReviews.firstWhere((review) => review.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add a new review
  static Future<ReviewModel> addReview({
    required String userId,
    required String username,
    required String routeId,
    required String routeName,
    required String content,
    required double punctualityRating,
    required double safetyRating,
    required double cleanlinessRating,
    required double overallRating,
    required String ageGroup,
  }) async {
    await initialize();
    
    // Generate a unique ID
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    final review = ReviewModel(
      id: id,
      userId: userId,
      username: username,
      routeId: routeId,
      routeName: routeName,
      content: content,
      punctualityRating: punctualityRating,
      safetyRating: safetyRating,
      cleanlinessRating: cleanlinessRating,
      overallRating: overallRating,
      ageGroup: ageGroup,
      createdAt: DateTime.now(),
    );
    
    print('Adding new review: ${review.id} for route ${review.routeId}');
    _cachedReviews.add(review);
    await _saveReviews();
    
    return review;
  }

  // Update an existing review
  static Future<ReviewModel?> updateReview({
    required String id,
    required String username,
    required String content,
    required double punctualityRating,
    required double safetyRating,
    required double cleanlinessRating,
    required double overallRating,
    required String ageGroup,
  }) async {
    await initialize();
    
    final index = _cachedReviews.indexWhere((review) => review.id == id);
    if (index == -1) return null;
    
    final oldReview = _cachedReviews[index];
    final updatedReview = ReviewModel(
      id: oldReview.id,
      userId: oldReview.userId,
      username: username,
      routeId: oldReview.routeId,
      routeName: oldReview.routeName,
      content: content,
      punctualityRating: punctualityRating,
      safetyRating: safetyRating,
      cleanlinessRating: cleanlinessRating,
      overallRating: overallRating,
      ageGroup: ageGroup,
      createdAt: oldReview.createdAt,
      updatedAt: DateTime.now(),
    );
    
    _cachedReviews[index] = updatedReview;
    await _saveReviews();
    
    return updatedReview;
  }

  // Delete a review
  static Future<bool> deleteReview(String id) async {
    await initialize();
    
    final index = _cachedReviews.indexWhere((review) => review.id == id);
    if (index == -1) return false;
    
    _cachedReviews.removeAt(index);
    await _saveReviews();
    
    return true;
  }
}