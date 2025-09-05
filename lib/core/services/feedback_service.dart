import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/feedback_models.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  late final Dio _dio;
  static const String _baseUrl = 'https://api.zenscape-tourism.com/v1/feedback';

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    _isInitialized = true;
  }

  // Heritage Site Reviews
  Future<Review> submitHeritageSiteReview({
    required String heritageSiteId,
    required String userId,
    required double rating,
    required String title,
    required String content,
    List<String>? images,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post('/heritage-sites/reviews', data: {
        'heritageSiteId': heritageSiteId,
        'userId': userId,
        'rating': rating,
        'title': title,
        'content': content,
        'images': images,
        'tags': tags,
        'metadata': metadata,
      });

      return Review.fromJson(response.data['review']);
    } on DioException catch (e) {
      throw FeedbackException('Failed to submit review: ${e.message}');
    }
  }

  Future<List<Review>> getHeritageSiteReviews({
    required String heritageSiteId,
    int page = 1,
    int limit = 20,
    double? minRating,
    String? sortBy,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'heritageSiteId': heritageSiteId,
        'page': page,
        'limit': limit,
      };
      if (minRating != null) queryParams['minRating'] = minRating;
      if (sortBy != null) queryParams['sortBy'] = sortBy;

      final response = await _dio.get('/heritage-sites/reviews', queryParameters: queryParams);
      final List<dynamic> reviewsData = response.data['reviews'];
      return reviewsData.map((r) => Review.fromJson(r)).toList();
    } on DioException catch (e) {
      throw FeedbackException('Failed to get reviews: ${e.message}');
    }
  }

  Future<Review> updateReview({
    required String reviewId,
    required String userId,
    double? rating,
    String? title,
    String? content,
    List<String>? images,
    List<String>? tags,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (rating != null) data['rating'] = rating;
      if (title != null) data['title'] = title;
      if (content != null) data['content'] = content;
      if (images != null) data['images'] = images;
      if (tags != null) data['tags'] = tags;

      final response = await _dio.put('/reviews/$reviewId', data: data);
      return Review.fromJson(response.data['review']);
    } on DioException catch (e) {
      throw FeedbackException('Failed to update review: ${e.message}');
    }
  }

  Future<void> deleteReview(String reviewId, String userId) async {
    try {
      await _dio.delete('/reviews/$reviewId', data: {'userId': userId});
    } on DioException catch (e) {
      throw FeedbackException('Failed to delete review: ${e.message}');
    }
  }

  // App Feedback
  Future<AppFeedback> submitAppFeedback({
    required String userId,
    required String category,
    required String title,
    required String description,
    String? priority,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post('/app', data: {
        'userId': userId,
        'category': category,
        'title': title,
        'description': description,
        'priority': priority,
        'attachments': attachments,
        'metadata': metadata,
      });

      return AppFeedback.fromJson(response.data['feedback']);
    } on DioException catch (e) {
      throw FeedbackException('Failed to submit app feedback: ${e.message}');
    }
  }

  Future<List<AppFeedback>> getAppFeedback({
    String? userId,
    String? category,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (userId != null) queryParams['userId'] = userId;
      if (category != null) queryParams['category'] = category;
      if (status != null) queryParams['status'] = status;

      final response = await _dio.get('/app', queryParameters: queryParams);
      final List<dynamic> feedbackData = response.data['feedback'];
      return feedbackData.map((f) => AppFeedback.fromJson(f)).toList();
    } on DioException catch (e) {
      throw FeedbackException('Failed to get app feedback: ${e.message}');
    }
  }

  // Rating Management
  Future<void> rateReview({
    required String reviewId,
    required String userId,
    required bool isHelpful,
  }) async {
    try {
      await _dio.post('/reviews/$reviewId/rate', data: {
        'userId': userId,
        'isHelpful': isHelpful,
      });
    } on DioException catch (e) {
      throw FeedbackException('Failed to rate review: ${e.message}');
    }
  }

  Future<void> reportReview({
    required String reviewId,
    required String userId,
    required String reason,
    String? description,
  }) async {
    try {
      await _dio.post('/reviews/$reviewId/report', data: {
        'userId': userId,
        'reason': reason,
        'description': description,
      });
    } on DioException catch (e) {
      throw FeedbackException('Failed to report review: ${e.message}');
    }
  }

  // Feedback Analytics
  Future<FeedbackAnalytics> getFeedbackAnalytics({
    String? heritageSiteId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (heritageSiteId != null) queryParams['heritageSiteId'] = heritageSiteId;
      if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _dio.get('/analytics', queryParameters: queryParams);
      return FeedbackAnalytics.fromJson(response.data['analytics']);
    } on DioException catch (e) {
      throw FeedbackException('Failed to get feedback analytics: ${e.message}');
    }
  }

  // User Feedback History
  Future<List<Review>> getUserReviewHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get('/users/$userId/reviews', queryParameters: {
        'page': page,
        'limit': limit,
      });

      final List<dynamic> reviewsData = response.data['reviews'];
      return reviewsData.map((r) => Review.fromJson(r)).toList();
    } on DioException catch (e) {
      throw FeedbackException('Failed to get user review history: ${e.message}');
    }
  }

  Future<List<AppFeedback>> getUserFeedbackHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get('/users/$userId/feedback', queryParameters: {
        'page': page,
        'limit': limit,
      });

      final List<dynamic> feedbackData = response.data['feedback'];
      return feedbackData.map((f) => AppFeedback.fromJson(f)).toList();
    } on DioException catch (e) {
      throw FeedbackException('Failed to get user feedback history: ${e.message}');
    }
  }

  // Moderation
  Future<void> moderateReview({
    required String reviewId,
    required String moderatorId,
    required String action,
    String? reason,
  }) async {
    try {
      await _dio.patch('/reviews/$reviewId/moderate', data: {
        'moderatorId': moderatorId,
        'action': action,
        'reason': reason,
      });
    } on DioException catch (e) {
      throw FeedbackException('Failed to moderate review: ${e.message}');
    }
  }

  Future<void> moderateAppFeedback({
    required String feedbackId,
    required String moderatorId,
    required String action,
    String? reason,
  }) async {
    try {
      await _dio.patch('/app/$feedbackId/moderate', data: {
        'moderatorId': moderatorId,
        'action': action,
        'reason': reason,
      });
    } on DioException catch (e) {
      throw FeedbackException('Failed to moderate app feedback: ${e.message}');
    }
  }
}

class FeedbackException implements Exception {
  final String message;
  FeedbackException(this.message);
  
  @override
  String toString() => 'FeedbackException: $message';
}
