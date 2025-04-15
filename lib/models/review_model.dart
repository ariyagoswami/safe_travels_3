import 'package:safe_travels_3/services/review_service.dart';

class ReviewModel {
  final String id;
  final String userId;
  final String username;
  final String routeId;
  final String routeName;
  final String content;
  final double punctualityRating;
  final double safetyRating;
  final double cleanlinessRating;
  final double overallRating;
  final String ageGroup; // 'Minor' or 'Adult'
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.routeId,
    required this.routeName,
    required this.content,
    required this.punctualityRating,
    required this.safetyRating,
    required this.cleanlinessRating,
    required this.overallRating,
    required this.ageGroup,
    required this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      routeId: json['routeId'] as String,
      routeName: json['routeName'] as String,
      content: json['content'] as String,
      punctualityRating: (json['punctualityRating'] as num).toDouble(),
      safetyRating: (json['safetyRating'] as num).toDouble(),
      cleanlinessRating: (json['cleanlinessRating'] as num).toDouble(),
      overallRating: (json['overallRating'] as num).toDouble(),
      ageGroup: json['ageGroup'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'routeId': routeId,
      'routeName': routeName,
      'content': content,
      'punctualityRating': punctualityRating,
      'safetyRating': safetyRating,
      'cleanlinessRating': cleanlinessRating,
      'overallRating': overallRating,
      'ageGroup': ageGroup,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

// These functions are now just wrappers around the ReviewService
// They are kept for backward compatibility
Future<List<ReviewModel>> getReviewsByRouteId(String routeId) async {
  return await ReviewService.getReviewsByRouteId(routeId);
}

Future<List<ReviewModel>> getReviewsByUserId(String userId) async {
  return await ReviewService.getReviewsByUserId(userId);
}

Future<List<ReviewModel>> getReviewsByAgeGroup(String ageGroup) async {
  return await ReviewService.getReviewsByAgeGroup(ageGroup);
}

Future<ReviewModel?> getReviewById(String id) async {
  return await ReviewService.getReviewById(id);
}

// Synchronous versions for compatibility with existing code
List<ReviewModel> getReviewsByRouteIdSync(String routeId) {
  // This is a temporary solution until all code is updated to use async methods
  return [];
}

List<ReviewModel> getReviewsByUserIdSync(String userId) {
  // This is a temporary solution until all code is updated to use async methods
  return [];
}

List<ReviewModel> getReviewsByAgeGroupSync(String ageGroup) {
  // This is a temporary solution until all code is updated to use async methods
  return [];
}

ReviewModel? getReviewByIdSync(String id) {
  // This is a temporary solution until all code is updated to use async methods
  return null;
}
