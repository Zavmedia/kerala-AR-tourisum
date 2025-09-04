import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/user_model.dart';
import '../models/heritage_site_model.dart';
import '../models/memory_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.zenscape-tourism.com/v1';
  static const String apiKey = 'your-api-key-here';
  
  late final Dio _dio;
  late final Connectivity _connectivity;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-Key': apiKey,
      },
    ));

    _connectivity = Connectivity();
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authentication token if available
          final token = await _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Handle token expiration
            await _handleTokenExpiration();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<String?> _getAuthToken() async {
    // Get token from secure storage
    // Implementation depends on your storage solution
    return null;
  }

  Future<void> _handleTokenExpiration() async {
    // Handle token refresh or logout
    // Implementation depends on your auth strategy
  }

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // User Authentication APIs
  Future<UserModel> login(String email, String password) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ApiException('Login failed: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserModel> register(String email, String password, String name) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'name': name,
      });

      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ApiException('Registration failed: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } on DioException catch (e) {
      // Logout should not fail even if API call fails
      print('Logout API call failed: ${e.message}');
    }
  }

  Future<UserModel> getCurrentUser() async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await _dio.get('/auth/me');
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserModel> updateUserProfile(UserModel user) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await _dio.put('/auth/profile', data: user.toJson());
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Heritage Sites APIs
  Future<List<HeritageSiteModel>> getHeritageSites({
    double? latitude,
    double? longitude,
    double? radius,
    String? category,
    String? searchQuery,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (latitude != null && longitude != null) {
        queryParams['latitude'] = latitude;
        queryParams['longitude'] = longitude;
        if (radius != null) queryParams['radius'] = radius;
      }

      if (category != null) queryParams['category'] = category;
      if (searchQuery != null) queryParams['search'] = searchQuery;

      final response = await _dio.get('/heritage-sites', queryParameters: queryParams);
      
      final List<dynamic> sitesData = response.data['sites'];
      return sitesData.map((site) => HeritageSiteModel.fromJson(site)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<HeritageSiteModel> getHeritageSiteById(String siteId) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await _dio.get('/heritage-sites/$siteId');
      return HeritageSiteModel.fromJson(response.data['site']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<HeritageSiteModel>> getFeaturedSites() async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await _dio.get('/heritage-sites/featured');
      final List<dynamic> sitesData = response.data['sites'];
      return sitesData.map((site) => HeritageSiteModel.fromJson(site)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<HeritageSiteModel>> getNearbySites(double latitude, double longitude, double radius) async {
    return getHeritageSites(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }

  // Memory APIs
  Future<List<MemoryModel>> getMemories({
    String? userId,
    String? siteId,
    String? type,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (userId != null) queryParams['userId'] = userId;
      if (siteId != null) queryParams['siteId'] = siteId;
      if (type != null) queryParams['type'] = type;

      final response = await _dio.get('/memories', queryParameters: queryParams);
      
      final List<dynamic> memoriesData = response.data['memories'];
      return memoriesData.map((memory) => MemoryModel.fromJson(memory)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<MemoryModel> createMemory(MemoryModel memory) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await _dio.post('/memories', data: memory.toJson());
      return MemoryModel.fromJson(response.data['memory']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<MemoryModel> updateMemory(String memoryId, MemoryModel memory) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await _dio.put('/memories/$memoryId', data: memory.toJson());
      return MemoryModel.fromJson(response.data['memory']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteMemory(String memoryId) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      await _dio.delete('/memories/$memoryId');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<MemoryModel> likeMemory(String memoryId) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await _dio.post('/memories/$memoryId/like');
      return MemoryModel.fromJson(response.data['memory']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<MemoryModel> addComment(String memoryId, String content) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await _dio.post('/memories/$memoryId/comments', data: {
        'content': content,
      });
      return MemoryModel.fromJson(response.data['memory']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // File Upload APIs
  Future<String> uploadImage(File imageFile) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _dio.post('/upload/image', data: formData);
      return response.data['url'];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<String> uploadVideo(File videoFile) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          videoFile.path,
          filename: videoFile.path.split('/').last,
        ),
      });

      final response = await _dio.post('/upload/video', data: formData);
      return response.data['url'];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<String> uploadAudio(File audioFile) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split('/').last,
        ),
      });

      final response = await _dio.post('/upload/audio', data: formData);
      return response.data['url'];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Trip Planning APIs
  Future<Map<String, dynamic>> generateItinerary({
    required int duration,
    required String travelerType,
    required double latitude,
    required double longitude,
    List<String>? interests,
    double? budget,
  }) async {
    if (!await _checkConnectivity()) {
      throw ApiException('No internet connection');
    }

    try {
      final response = await _dio.post('/trip-planning/generate', data: {
        'duration': duration,
        'travelerType': travelerType,
        'latitude': latitude,
        'longitude': longitude,
        'interests': interests,
        'budget': budget,
      });

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Error handling
  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timeout. Please check your internet connection.');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Unknown error occurred';
        
        switch (statusCode) {
          case 400:
            return ApiException('Bad request: $message');
          case 401:
            return ApiException('Unauthorized: Please login again');
          case 403:
            return ApiException('Forbidden: $message');
          case 404:
            return ApiException('Not found: $message');
          case 500:
            return ApiException('Server error: Please try again later');
          default:
            return ApiException('Error $statusCode: $message');
        }
      
      case DioExceptionType.cancel:
        return ApiException('Request was cancelled');
      
      case DioExceptionType.connectionError:
        return ApiException('Connection error. Please check your internet connection.');
      
      default:
        return ApiException('An unexpected error occurred: ${error.message}');
    }
  }
}

class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
}
