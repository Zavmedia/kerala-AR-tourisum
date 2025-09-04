import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../models/heritage_site_model.dart';

class ARService {
  static const MethodChannel _channel = MethodChannel('zenscape_ar_service');
  
  bool _isInitialized = false;
  bool _isTracking = false;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionSubscription;
  
  final StreamController<AREvent> _arEventController = StreamController<AREvent>.broadcast();
  final StreamController<HeritageSiteModel> _siteDetectionController = StreamController<HeritageSiteModel>.broadcast();
  
  Stream<AREvent> get arEvents => _arEventController.stream;
  Stream<HeritageSiteModel> get siteDetection => _siteDetectionController.stream;
  
  bool get isInitialized => _isInitialized;
  bool get isTracking => _isTracking;
  Position? get currentPosition => _currentPosition;

  ARService._();
  static final ARService _instance = ARService._();
  static ARService get instance => _instance;

  Future<bool> initialize() async {
    try {
      // Initialize AR session
      final result = await _channel.invokeMethod('initializeAR');
      _isInitialized = result == true;
      
      if (_isInitialized) {
        _setupMethodCallHandler();
        await _startLocationTracking();
      }
      
      return _isInitialized;
    } catch (e) {
      print('AR initialization failed: $e');
      return false;
    }
  }

  void _setupMethodCallHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onAREvent':
          _handleAREvent(call.arguments);
          break;
        case 'onSiteDetected':
          _handleSiteDetection(call.arguments);
          break;
        case 'onTrackingStateChanged':
          _handleTrackingStateChanged(call.arguments);
          break;
      }
    });
  }

  void _handleAREvent(dynamic arguments) {
    try {
      final event = AREvent.fromMap(Map<String, dynamic>.from(arguments));
      _arEventController.add(event);
    } catch (e) {
      print('Error handling AR event: $e');
    }
  }

  void _handleSiteDetection(dynamic arguments) {
    try {
      final siteData = Map<String, dynamic>.from(arguments);
      final site = HeritageSiteModel.fromJson(siteData);
      _siteDetectionController.add(site);
    } catch (e) {
      print('Error handling site detection: $e');
    }
  }

  void _handleTrackingStateChanged(dynamic arguments) {
    try {
      final isTracking = arguments['isTracking'] as bool;
      _isTracking = isTracking;
    } catch (e) {
      print('Error handling tracking state: $e');
    }
  }

  Future<void> _startLocationTracking() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((position) {
        _currentPosition = position;
        _updateARLocation(position);
      });
    } catch (e) {
      print('Location tracking failed: $e');
    }
  }

  Future<void> _updateARLocation(Position position) async {
    try {
      await _channel.invokeMethod('updateLocation', {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'altitude': position.altitude,
        'accuracy': position.accuracy,
      });
    } catch (e) {
      print('Failed to update AR location: $e');
    }
  }

  Future<bool> startARSession() async {
    if (!_isInitialized) {
      throw ARException('AR not initialized');
    }

    try {
      final result = await _channel.invokeMethod('startARSession');
      return result == true;
    } catch (e) {
      throw ARException('Failed to start AR session: $e');
    }
  }

  Future<void> stopARSession() async {
    try {
      await _channel.invokeMethod('stopARSession');
    } catch (e) {
      print('Failed to stop AR session: $e');
    }
  }

  Future<void> loadARModel(ARModel model) async {
    if (!_isInitialized) {
      throw ARException('AR not initialized');
    }

    try {
      await _channel.invokeMethod('loadARModel', {
        'modelId': model.id,
        'modelUrl': model.modelUrl,
        'scale': model.metadata.scale,
        'position': model.metadata.position,
        'rotation': model.metadata.rotation,
        'isInteractive': model.metadata.isInteractive,
      });
    } catch (e) {
      throw ARException('Failed to load AR model: $e');
    }
  }

  Future<void> unloadARModel(String modelId) async {
    try {
      await _channel.invokeMethod('unloadARModel', {'modelId': modelId});
    } catch (e) {
      print('Failed to unload AR model: $e');
    }
  }

  Future<void> showARModel(String modelId) async {
    try {
      await _channel.invokeMethod('showARModel', {'modelId': modelId});
    } catch (e) {
      throw ARException('Failed to show AR model: $e');
    }
  }

  Future<void> hideARModel(String modelId) async {
    try {
      await _channel.invokeMethod('hideARModel', {'modelId': modelId});
    } catch (e) {
      throw ARException('Failed to hide AR model: $e');
    }
  }

  Future<void> animateARModel(String modelId, String animationType) async {
    try {
      await _channel.invokeMethod('animateARModel', {
        'modelId': modelId,
        'animationType': animationType,
      });
    } catch (e) {
      throw ARException('Failed to animate AR model: $e');
    }
  }

  Future<void> setARModelPosition(String modelId, List<double> position) async {
    try {
      await _channel.invokeMethod('setARModelPosition', {
        'modelId': modelId,
        'position': position,
      });
    } catch (e) {
      throw ARException('Failed to set AR model position: $e');
    }
  }

  Future<void> setARModelRotation(String modelId, List<double> rotation) async {
    try {
      await _channel.invokeMethod('setARModelRotation', {
        'modelId': modelId,
        'rotation': rotation,
      });
    } catch (e) {
      throw ARException('Failed to set AR model rotation: $e');
    }
  }

  Future<void> setARModelScale(String modelId, double scale) async {
    try {
      await _channel.invokeMethod('setARModelScale', {
        'modelId': modelId,
        'scale': scale,
      });
    } catch (e) {
      throw ARException('Failed to set AR model scale: $e');
    }
  }

  Future<void> enableARLighting(bool enabled) async {
    try {
      await _channel.invokeMethod('enableARLighting', {'enabled': enabled});
    } catch (e) {
      print('Failed to toggle AR lighting: $e');
    }
  }

  Future<void> setARLightingIntensity(double intensity) async {
    try {
      await _channel.invokeMethod('setARLightingIntensity', {'intensity': intensity});
    } catch (e) {
      print('Failed to set AR lighting intensity: $e');
    }
  }

  Future<void> enableARShadows(bool enabled) async {
    try {
      await _channel.invokeMethod('enableARShadows', {'enabled': enabled});
    } catch (e) {
      print('Failed to toggle AR shadows: $e');
    }
  }

  Future<void> captureARScreenshot() async {
    try {
      await _channel.invokeMethod('captureARScreenshot');
    } catch (e) {
      throw ARException('Failed to capture AR screenshot: $e');
    }
  }

  Future<void> recordARVideo() async {
    try {
      await _channel.invokeMethod('recordARVideo');
    } catch (e) {
      throw ARException('Failed to start AR video recording: $e');
    }
  }

  Future<void> stopARVideoRecording() async {
    try {
      await _channel.invokeMethod('stopARVideoRecording');
    } catch (e) {
      throw ARException('Failed to stop AR video recording: $e');
    }
  }

  Future<List<ARModel>> getAvailableARModels() async {
    try {
      final result = await _channel.invokeMethod('getAvailableARModels');
      final List<dynamic> modelsData = result as List<dynamic>;
      return modelsData.map((model) => ARModel.fromJson(model as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Failed to get available AR models: $e');
      return [];
    }
  }

  Future<ARModel?> getARModelById(String modelId) async {
    try {
      final result = await _channel.invokeMethod('getARModelById', {'modelId': modelId});
      if (result != null) {
        return ARModel.fromJson(result as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Failed to get AR model by ID: $e');
      return null;
    }
  }

  Future<bool> isARModelLoaded(String modelId) async {
    try {
      final result = await _channel.invokeMethod('isARModelLoaded', {'modelId': modelId});
      return result == true;
    } catch (e) {
      print('Failed to check AR model load status: $e');
      return false;
    }
  }

  Future<void> resetARScene() async {
    try {
      await _channel.invokeMethod('resetARScene');
    } catch (e) {
      throw ARException('Failed to reset AR scene: $e');
    }
  }

  Future<void> pauseARSession() async {
    try {
      await _channel.invokeMethod('pauseARSession');
    } catch (e) {
      print('Failed to pause AR session: $e');
    }
  }

  Future<void> resumeARSession() async {
    try {
      await _channel.invokeMethod('resumeARSession');
    } catch (e) {
      print('Failed to resume AR session: $e');
    }
  }

  Future<ARCapabilities> getARCapabilities() async {
    try {
      final result = await _channel.invokeMethod('getARCapabilities');
      return ARCapabilities.fromMap(Map<String, dynamic>.from(result));
    } catch (e) {
      print('Failed to get AR capabilities: $e');
      return ARCapabilities();
    }
  }

  Future<void> loadLocalModel({
    required String modelId,
    required String assetPath,
    double scale = 1.0,
    List<double> position = const [0, 0, -1],
    List<double> rotation = const [0, 0, 0],
    bool isInteractive = true,
  }) async {
    if (!_isInitialized) {
      throw ARException('AR not initialized');
    }
    try {
      await _channel.invokeMethod('loadLocalModel', {
        'modelId': modelId,
        'assetPath': assetPath,
        'scale': scale,
        'position': position,
        'rotation': rotation,
        'isInteractive': isInteractive,
      });
    } catch (e) {
      throw ARException('Failed to load local model: $e');
    }
  }

  Future<void> placeModelAt({
    required String modelId,
    List<double> position = const [0, 0, -1],
    List<double> rotation = const [0, 0, 0],
    double? scale,
  }) async {
    try {
      await _channel.invokeMethod('placeModelAt', {
        'modelId': modelId,
        'position': position,
        'rotation': rotation,
        if (scale != null) 'scale': scale,
      });
    } catch (e) {
      throw ARException('Failed to place model: $e');
    }
  }

  Future<void> dispose() async {
    await _positionSubscription?.cancel();
    await _arEventController.close();
    await _siteDetectionController.close();
    
    try {
      await _channel.invokeMethod('disposeAR');
    } catch (e) {
      print('Failed to dispose AR: $e');
    }
  }
}

class AREvent {
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  AREvent({
    required this.type,
    required this.data,
    required this.timestamp,
  });

  factory AREvent.fromMap(Map<String, dynamic> map) {
    return AREvent(
      type: map['type'] as String,
      data: Map<String, dynamic>.from(map['data'] as Map),
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class ARCapabilities {
  final bool supportsPlaneDetection;
  final bool supportsImageTracking;
  final bool supportsObjectTracking;
  final bool supportsFaceTracking;
  final bool supportsBodyTracking;
  final bool supportsLightEstimation;
  final bool supportsEnvironmentTexturing;
  final List<String> supportedFormats;

  ARCapabilities({
    this.supportsPlaneDetection = false,
    this.supportsImageTracking = false,
    this.supportsObjectTracking = false,
    this.supportsFaceTracking = false,
    this.supportsBodyTracking = false,
    this.supportsLightEstimation = false,
    this.supportsEnvironmentTexturing = false,
    this.supportedFormats = const [],
  });

  factory ARCapabilities.fromMap(Map<String, dynamic> map) {
    return ARCapabilities(
      supportsPlaneDetection: map['supportsPlaneDetection'] as bool? ?? false,
      supportsImageTracking: map['supportsImageTracking'] as bool? ?? false,
      supportsObjectTracking: map['supportsObjectTracking'] as bool? ?? false,
      supportsFaceTracking: map['supportsFaceTracking'] as bool? ?? false,
      supportsBodyTracking: map['supportsBodyTracking'] as bool? ?? false,
      supportsLightEstimation: map['supportsLightEstimation'] as bool? ?? false,
      supportsEnvironmentTexturing: map['supportsEnvironmentTexturing'] as bool? ?? false,
      supportedFormats: List<String>.from(map['supportedFormats'] as List? ?? []),
    );
  }
}

class ARException implements Exception {
  final String message;
  
  ARException(this.message);
  
  @override
  String toString() => 'ARException: $message';
}
