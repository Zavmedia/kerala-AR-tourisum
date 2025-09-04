import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'database_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _isLoggedInKey = 'is_logged_in';

  late SharedPreferences _prefs;
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService.instance;
  final Connectivity _connectivity = Connectivity();

  UserModel? _currentUser;
  bool _isLoggedIn = false;

  AuthService._();
  static final AuthService _instance = AuthService._();
  static AuthService get instance => _instance;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadStoredAuth();
  }

  Future<void> _loadStoredAuth() async {
    _isLoggedIn = _prefs.getBool(_isLoggedInKey) ?? false;
    
    if (_isLoggedIn) {
      _currentUser = await _databaseService.getCurrentUser();
      if (_currentUser == null) {
        await logout();
      }
    }
  }

  Future<AuthResult> login(String email, String password) async {
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return AuthResult.error('No internet connection. Please check your network.');
      }

      // Attempt login via API
      final user = await _apiService.login(email, password);
      
      // Save user data locally
      await _databaseService.saveUser(user);
      await _saveAuthTokens('mock_token', 'mock_refresh_token');
      
      _currentUser = user;
      _isLoggedIn = true;
      await _prefs.setBool(_isLoggedInKey, true);

      return AuthResult.success(user);
    } on ApiException catch (e) {
      return AuthResult.error(e.message);
    } catch (e) {
      return AuthResult.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<AuthResult> register(String email, String password, String name) async {
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return AuthResult.error('No internet connection. Please check your network.');
      }

      // Attempt registration via API
      final user = await _apiService.register(email, password, name);
      
      // Save user data locally
      await _databaseService.saveUser(user);
      await _saveAuthTokens('mock_token', 'mock_refresh_token');
      
      _currentUser = user;
      _isLoggedIn = true;
      await _prefs.setBool(_isLoggedInKey, true);

      return AuthResult.success(user);
    } on ApiException catch (e) {
      return AuthResult.error(e.message);
    } catch (e) {
      return AuthResult.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return AuthResult.error('No internet connection. Please check your network.');
      }

      // Mock Google login - in real implementation, use Google Sign-In
      await Future.delayed(const Duration(seconds: 2));
      
      final user = UserModel(
        id: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user@gmail.com',
        name: 'Google User',
        profileImageUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        preferences: UserPreferences(
          language: 'en',
          theme: 'light',
          notificationsEnabled: true,
          locationTrackingEnabled: true,
          arSubtitlesEnabled: true,
          preferredTravelerType: 'Cultural Enthusiast',
          interests: ['heritage', 'culture', 'history'],
        ),
        stats: UserStats(
          sitesVisited: 0,
          photosCaptured: 0,
          arExperiences: 0,
          socialShares: 0,
          totalDistanceTraveled: 0,
          badgesEarned: 0,
          achievements: [],
        ),
      );
      
      // Save user data locally
      await _databaseService.saveUser(user);
      await _saveAuthTokens('google_token', 'google_refresh_token');
      
      _currentUser = user;
      _isLoggedIn = true;
      await _prefs.setBool(_isLoggedInKey, true);

      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.error('Google login failed: ${e.toString()}');
    }
  }

  Future<AuthResult> loginWithOTP(String phoneNumber) async {
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return AuthResult.error('No internet connection. Please check your network.');
      }

      // Mock OTP login - in real implementation, use Firebase Auth or similar
      await Future.delayed(const Duration(seconds: 2));
      
      final user = UserModel(
        id: 'otp_user_${DateTime.now().millisecondsSinceEpoch}',
        email: '$phoneNumber@temp.com',
        name: 'OTP User',
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        preferences: UserPreferences(
          language: 'en',
          theme: 'light',
          notificationsEnabled: true,
          locationTrackingEnabled: true,
          arSubtitlesEnabled: true,
          preferredTravelerType: 'Cultural Enthusiast',
          interests: ['heritage', 'culture', 'history'],
        ),
        stats: UserStats(
          sitesVisited: 0,
          photosCaptured: 0,
          arExperiences: 0,
          socialShares: 0,
          totalDistanceTraveled: 0,
          badgesEarned: 0,
          achievements: [],
        ),
      );
      
      // Save user data locally
      await _databaseService.saveUser(user);
      await _saveAuthTokens('otp_token', 'otp_refresh_token');
      
      _currentUser = user;
      _isLoggedIn = true;
      await _prefs.setBool(_isLoggedInKey, true);

      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.error('OTP login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      // Call logout API if connected
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        await _apiService.logout();
      }
    } catch (e) {
      // Logout should not fail even if API call fails
      print('Logout API call failed: $e');
    }

    // Clear local data
    await _clearAuthData();
    
    _currentUser = null;
    _isLoggedIn = false;
  }

  Future<void> _clearAuthData() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_isLoggedInKey);
    await _databaseService.clearUser();
  }

  Future<void> _saveAuthTokens(String token, String refreshToken) async {
    await _prefs.setString(_tokenKey, token);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> getAuthToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<AuthResult> updateProfile(UserModel updatedUser) async {
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return AuthResult.error('No internet connection. Please check your network.');
      }

      // Update via API
      final user = await _apiService.updateUserProfile(updatedUser);
      
      // Update local data
      await _databaseService.saveUser(user);
      _currentUser = user;

      return AuthResult.success(user);
    } on ApiException catch (e) {
      return AuthResult.error(e.message);
    } catch (e) {
      return AuthResult.error('Profile update failed: ${e.toString()}');
    }
  }

  Future<AuthResult> updatePreferences(UserPreferences preferences) async {
    if (_currentUser == null) {
      return AuthResult.error('User not logged in');
    }

    final updatedUser = _currentUser!.copyWith(preferences: preferences);
    return await updateProfile(updatedUser);
  }

  Future<bool> isTokenValid() async {
    final token = await getAuthToken();
    if (token == null) return false;

    // In a real implementation, you would validate the token with the server
    // For now, we'll assume the token is valid if it exists
    return true;
  }

  Future<AuthResult> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        return AuthResult.error('No refresh token available');
      }

      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return AuthResult.error('No internet connection. Please check your network.');
      }

      // In a real implementation, call the refresh token API
      // For now, we'll simulate a successful refresh
      await _saveAuthTokens('new_token', 'new_refresh_token');
      
      return AuthResult.success(_currentUser!);
    } catch (e) {
      return AuthResult.error('Token refresh failed: ${e.toString()}');
    }
  }

  Future<void> deleteAccount() async {
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        // In a real implementation, call the delete account API
        // await _apiService.deleteAccount();
      }
    } catch (e) {
      print('Delete account API call failed: $e');
    }

    // Clear all local data
    await _clearAuthData();
    await _databaseService.clearCache();
    
    _currentUser = null;
    _isLoggedIn = false;
  }

  Future<bool> hasStoredCredentials() async {
    final token = await getAuthToken();
    final isLoggedIn = _prefs.getBool(_isLoggedInKey) ?? false;
    return token != null && isLoggedIn;
  }

  Future<AuthResult> autoLogin() async {
    if (!await hasStoredCredentials()) {
      return AuthResult.error('No stored credentials found');
    }

    if (!await isTokenValid()) {
      final refreshResult = await refreshToken();
      if (!refreshResult.isSuccess) {
        await logout();
        return refreshResult;
      }
    }

    // Load user from local storage
    final user = await _databaseService.getCurrentUser();
    if (user == null) {
      await logout();
      return AuthResult.error('User data not found');
    }

    _currentUser = user;
    _isLoggedIn = true;

    return AuthResult.success(user);
  }
}

class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? error;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.error,
  });

  factory AuthResult.success(UserModel user) {
    return AuthResult._(isSuccess: true, user: user);
  }

  factory AuthResult.error(String error) {
    return AuthResult._(isSuccess: false, error: error);
  }
}
