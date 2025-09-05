import 'package:connectivity_plus/connectivity_plus.dart';
import 'api_service.dart';
import 'database_service.dart';
import 'auth_service.dart';
import 'ar_service.dart';
import 'ar_model_service.dart';
import 'voice_search_service.dart';
import 'localization_service.dart';
import 'advanced_search_service.dart';
import 'social_service.dart';
import 'gamification_service.dart';
import 'offline_sync_service.dart';
import 'embedding_service.dart';
import 'logging_service.dart';
import 'payment_service.dart';
import 'partnership_service.dart';
import 'feedback_service.dart';

class ServiceManager {
  static final ServiceManager _instance = ServiceManager._internal();
  factory ServiceManager() => _instance;
  ServiceManager._internal();

  // Core services
  late final ApiService _apiService;
  late final DatabaseService _databaseService;
  late final AuthService _authService;
  late final ARService _arService;
  
  // New services
  late final ARModelService _arModelService;
  late final VoiceSearchService _voiceSearchService;
  late final LocalizationService _localizationService;
  late final AdvancedSearchService _advancedSearchService;
  late final SocialService _socialService;
  late final GamificationService _gamificationService;
  late final OfflineSyncService _offlineSyncService;
  late final EmbeddingService _embeddingService;
  late final LoggingService _loggingService;
  
  // Business services
  late final PaymentService _paymentService;
  late final PartnershipService _partnershipService;
  late final FeedbackService _feedbackService;

  // Service getters
  ApiService get apiService => _apiService;
  DatabaseService get databaseService => _databaseService;
  AuthService get authService => _authService;
  ARService get arService => _arService;
  ARModelService get arModelService => _arModelService;
  VoiceSearchService get voiceSearchService => _voiceSearchService;
  LocalizationService get localizationService => _localizationService;
  AdvancedSearchService get advancedSearchService => _advancedSearchService;
  SocialService get socialService => _socialService;
  GamificationService get gamificationService => _gamificationService;
  OfflineSyncService get offlineSyncService => _offlineSyncService;
  EmbeddingService get embeddingService => _embeddingService;
  LoggingService get loggingService => _loggingService;
  
  // Business service getters
  PaymentService get paymentService => _paymentService;
  PartnershipService get partnershipService => _partnershipService;
  FeedbackService get feedbackService => _feedbackService;

  Future<void> initialize() async {
    try {
      print('🚀 Initializing Service Manager...');

      // Initialize core services
      print('📡 Initializing API Service...');
      _apiService = ApiService();
      await _apiService.initialize();

      print('💾 Initializing Database Service...');
      _databaseService = DatabaseService();
      await _databaseService.initialize();

      print('🔐 Initializing Auth Service...');
      _authService = AuthService();
      await _authService.initialize();

      print('🕶️ Initializing AR Service...');
      _arService = ARService.instance;
      await _arService.initialize();

      // Initialize new services
      print('🎯 Initializing AR Model Service...');
      _arModelService = ARModelService();
      await _arModelService.initialize();

      print('🎤 Initializing Voice Search Service...');
      _voiceSearchService = VoiceSearchService();
      await _voiceSearchService.initialize();

      print('🌍 Initializing Localization Service...');
      _localizationService = LocalizationService();
      await _localizationService.initialize();

      print('🔍 Initializing Advanced Search Service...');
      _advancedSearchService = AdvancedSearchService();
      await _advancedSearchService.initialize();

      print('👥 Initializing Social Service...');
      _socialService = SocialService();
      await _socialService.initialize();

      print('🏆 Initializing Gamification Service...');
      _gamificationService = GamificationService();
      await _gamificationService.initialize();

      print('🛜 Initializing Offline Sync Service...');
      _offlineSyncService = OfflineSyncService();
      await _offlineSyncService.initialize(api: _apiService, db: _databaseService);

      print('🧠 Initializing Embedding Service (v1.5)...');
      _embeddingService = EmbeddingService();
      await _embeddingService.initialize();

      print('🪵 Initializing Logging Service...');
      _loggingService = LoggingService();
      await _loggingService.initialize();

      // Initialize business services
      print('💳 Initializing Payment Service...');
      _paymentService = PaymentService();
      await _paymentService.initialize();

      print('🤝 Initializing Partnership Service...');
      _partnershipService = PartnershipService();
      await _partnershipService.initialize();

      print('📝 Initializing Feedback Service...');
      _feedbackService = FeedbackService();
      await _feedbackService.initialize();

      // Prepare offline AR model assets bundled with app
      await _offlineSyncService.prepareOfflineARAssets([
        {'id': 'fort_kochi', 'assetPath': 'assets/models/fort_kochi.glb'},
        {'id': 'mattancherry_palace', 'assetPath': 'assets/models/mattancherry_palace.glb'},
        {'id': 'jewish_synagogue', 'assetPath': 'assets/models/jewish_synagogue.glb'},
      ]);

      print('✅ All services initialized successfully!');
    } catch (e) {
      print('❌ Service Manager initialization failed: $e');
      rethrow;
    }
  }

  Future<void> dispose() async {
    try {
      print('🔄 Disposing Service Manager...');
      await _voiceSearchService.dispose();
      await _offlineSyncService.dispose();
      print('✅ Service Manager disposed successfully!');
    } catch (e) {
      print('❌ Service Manager disposal failed: $e');
    }
  }

  Future<Map<String, bool>> healthCheck() async {
    final healthStatus = <String, bool>{};
    
    try {
      healthStatus['api_service'] = _apiService.isInitialized;
      healthStatus['database_service'] = _databaseService.isInitialized;
      healthStatus['auth_service'] = _authService.isInitialized;
      healthStatus['ar_service'] = _arService.isInitialized;
      healthStatus['ar_model_service'] = _arModelService.isInitialized;
      healthStatus['voice_search_service'] = _voiceSearchService.isInitialized;
      healthStatus['localization_service'] = _localizationService.isInitialized;
      healthStatus['advanced_search_service'] = _advancedSearchService.isInitialized;
      healthStatus['social_service'] = _socialService.isInitialized;
      healthStatus['gamification_service'] = _gamificationService.isInitialized;
      healthStatus['offline_sync_service'] = _offlineSyncService.isInitialized;
      healthStatus['embedding_service'] = _embeddingService.isInitialized;
      healthStatus['logging_service'] = _loggingService.isInitialized;
      healthStatus['payment_service'] = _paymentService.isInitialized;
      healthStatus['partnership_service'] = _partnershipService.isInitialized;
      healthStatus['feedback_service'] = _feedbackService.isInitialized;
    } catch (e) {
      print('Health check failed: $e');
      healthStatus['overall'] = false;
      return healthStatus;
    }
    
    healthStatus['overall'] = healthStatus.values.every((status) => status);
    return healthStatus;
  }

  Future<Map<String, dynamic>> getServiceStatus() async {
    final health = await healthCheck();
    final status = <String, dynamic>{
      'health': health,
      'services_count': 16,
      'healthy_services': health.values.where((status) => status).length,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    return status;
  }
}
