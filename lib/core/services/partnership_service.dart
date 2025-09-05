import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/partnership_models.dart';

class PartnershipService {
  static final PartnershipService _instance = PartnershipService._internal();
  factory PartnershipService() => _instance;
  PartnershipService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  late final Dio _dio;
  static const String _baseUrl = 'https://api.zenscape-tourism.com/v1/partnerships';

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    _isInitialized = true;
  }

  // Local Business Partnerships
  Future<List<LocalBusiness>> getLocalBusinesses({
    String? heritageSiteId,
    String? category,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (heritageSiteId != null) queryParams['heritageSiteId'] = heritageSiteId;
      if (category != null) queryParams['category'] = category;
      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;
      if (radius != null) queryParams['radius'] = radius;

      final response = await _dio.get('/businesses', queryParameters: queryParams);
      final List<dynamic> businessesData = response.data['businesses'];
      return businessesData.map((b) => LocalBusiness.fromJson(b)).toList();
    } on DioException catch (e) {
      throw PartnershipException('Failed to get local businesses: ${e.message}');
    }
  }

  Future<LocalBusiness> getLocalBusinessById(String businessId) async {
    try {
      final response = await _dio.get('/businesses/$businessId');
      return LocalBusiness.fromJson(response.data['business']);
    } on DioException catch (e) {
      throw PartnershipException('Failed to get business: ${e.message}');
    }
  }

  Future<void> addLocalBusiness(LocalBusiness business) async {
    try {
      await _dio.post('/businesses', data: business.toJson());
    } on DioException catch (e) {
      throw PartnershipException('Failed to add business: ${e.message}');
    }
  }

  Future<void> updateLocalBusiness(String businessId, LocalBusiness business) async {
    try {
      await _dio.put('/businesses/$businessId', data: business.toJson());
    } on DioException catch (e) {
      throw PartnershipException('Failed to update business: ${e.message}');
    }
  }

  // Tour Guide Partnerships
  Future<List<TourGuide>> getTourGuides({
    String? heritageSiteId,
    String? language,
    bool? isAvailable,
    double? rating,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (heritageSiteId != null) queryParams['heritageSiteId'] = heritageSiteId;
      if (language != null) queryParams['language'] = language;
      if (isAvailable != null) queryParams['isAvailable'] = isAvailable;
      if (rating != null) queryParams['rating'] = rating;

      final response = await _dio.get('/guides', queryParameters: queryParams);
      final List<dynamic> guidesData = response.data['guides'];
      return guidesData.map((g) => TourGuide.fromJson(g)).toList();
    } on DioException catch (e) {
      throw PartnershipException('Failed to get tour guides: ${e.message}');
    }
  }

  Future<TourGuide> getTourGuideById(String guideId) async {
    try {
      final response = await _dio.get('/guides/$guideId');
      return TourGuide.fromJson(response.data['guide']);
    } on DioException catch (e) {
      throw PartnershipException('Failed to get guide: ${e.message}');
    }
  }

  Future<BookingResult> bookTourGuide({
    required String guideId,
    required String userId,
    required DateTime tourDate,
    required int duration,
    required String heritageSiteId,
    String? specialRequirements,
  }) async {
    try {
      final response = await _dio.post('/guides/book', data: {
        'guideId': guideId,
        'userId': userId,
        'tourDate': tourDate.toIso8601String(),
        'duration': duration,
        'heritageSiteId': heritageSiteId,
        'specialRequirements': specialRequirements,
      });

      return BookingResult.fromJson(response.data);
    } on DioException catch (e) {
      throw PartnershipException('Failed to book guide: ${e.message}');
    }
  }

  // Revenue Sharing
  Future<RevenueShare> getRevenueShare(String partnershipId) async {
    try {
      final response = await _dio.get('/revenue/$partnershipId');
      return RevenueShare.fromJson(response.data['revenueShare']);
    } on DioException catch (e) {
      throw PartnershipException('Failed to get revenue share: ${e.message}');
    }
  }

  Future<List<RevenueTransaction>> getRevenueHistory({
    required String partnerId,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'partnerId': partnerId,
        'page': page,
        'limit': limit,
      };
      if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _dio.get('/revenue/history', queryParameters: queryParams);
      final List<dynamic> transactionsData = response.data['transactions'];
      return transactionsData.map((t) => RevenueTransaction.fromJson(t)).toList();
    } on DioException catch (e) {
      throw PartnershipException('Failed to get revenue history: ${e.message}');
    }
  }

  // Partnership Management
  Future<Partnership> createPartnership(PartnershipRequest request) async {
    try {
      final response = await _dio.post('/create', data: request.toJson());
      return Partnership.fromJson(response.data['partnership']);
    } on DioException catch (e) {
      throw PartnershipException('Failed to create partnership: ${e.message}');
    }
  }

  Future<List<Partnership>> getPartnerships({
    String? partnerId,
    PartnershipStatus? status,
    String? type,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (partnerId != null) queryParams['partnerId'] = partnerId;
      if (status != null) queryParams['status'] = status.name;
      if (type != null) queryParams['type'] = type;

      final response = await _dio.get('/list', queryParameters: queryParams);
      final List<dynamic> partnershipsData = response.data['partnerships'];
      return partnershipsData.map((p) => Partnership.fromJson(p)).toList();
    } on DioException catch (e) {
      throw PartnershipException('Failed to get partnerships: ${e.message}');
    }
  }

  Future<void> updatePartnershipStatus(String partnershipId, PartnershipStatus status) async {
    try {
      await _dio.patch('/$partnershipId/status', data: {'status': status.name});
    } on DioException catch (e) {
      throw PartnershipException('Failed to update partnership status: ${e.message}');
    }
  }

  // Analytics and Reporting
  Future<PartnershipAnalytics> getPartnershipAnalytics({
    String? partnerId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (partnerId != null) queryParams['partnerId'] = partnerId;
      if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _dio.get('/analytics', queryParameters: queryParams);
      return PartnershipAnalytics.fromJson(response.data['analytics']);
    } on DioException catch (e) {
      throw PartnershipException('Failed to get analytics: ${e.message}');
    }
  }
}

class PartnershipException implements Exception {
  final String message;
  PartnershipException(this.message);
  
  @override
  String toString() => 'PartnershipException: $message';
}
