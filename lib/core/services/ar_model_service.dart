import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ARModel {
  final String id;
  final String name;
  final String modelPath;
  final String texturePath;
  final Map<String, dynamic> metadata;
  final double scale;
  final List<double> position;
  final List<double> rotation;

  ARModel({
    required this.id,
    required this.name,
    required this.modelPath,
    required this.texturePath,
    required this.metadata,
    this.scale = 1.0,
    this.position = const [0, 0, 0],
    this.rotation = const [0, 0, 0],
  });

  factory ARModel.fromJson(Map<String, dynamic> json) {
    return ARModel(
      id: json['id'],
      name: json['name'],
      modelPath: json['modelPath'],
      texturePath: json['texturePath'],
      metadata: json['metadata'] ?? {},
      scale: json['scale']?.toDouble() ?? 1.0,
      position: List<double>.from(json['position'] ?? [0, 0, 0]),
      rotation: List<double>.from(json['rotation'] ?? [0, 0, 0]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'modelPath': modelPath,
      'texturePath': texturePath,
      'metadata': metadata,
      'scale': scale,
      'position': position,
      'rotation': rotation,
    };
  }
}

class ARModelService {
  static final ARModelService _instance = ARModelService._internal();
  factory ARModelService() => _instance;
  ARModelService._internal();

  final Map<String, ARModel> _models = {};
  final Map<String, dynamic> _loadedModels = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadDefaultModels();
      await _loadCustomModels();
      _isInitialized = true;
    } catch (e) {
      print('AR Model Service initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _loadDefaultModels() async {
    // Load built-in heritage site models
    final defaultModels = [
      {
        'id': 'fort_kochi',
        'name': 'Fort Kochi',
        'modelPath': 'assets/models/fort_kochi.glb',
        'texturePath': 'assets/textures/fort_kochi.jpg',
        'metadata': {
          'era': 'Portuguese Colonial',
          'year': '1503',
          'style': 'European Fortress',
          'materials': ['Stone', 'Laterite'],
        },
        'scale': 0.5,
        'position': [0, 0, -2],
        'rotation': [0, 0, 0],
      },
      {
        'id': 'mattancherry_palace',
        'name': 'Mattancherry Palace',
        'modelPath': 'assets/models/mattancherry_palace.glb',
        'texturePath': 'assets/textures/mattancherry_palace.jpg',
        'metadata': {
          'era': 'Kerala Architecture',
          'year': '1555',
          'style': 'Traditional Kerala',
          'materials': ['Wood', 'Laterite', 'Clay'],
        },
        'scale': 0.6,
        'position': [0, 0, -2],
        'rotation': [0, 0, 0],
      },
      {
        'id': 'jewish_synagogue',
        'name': 'Jewish Synagogue',
        'modelPath': 'assets/models/jewish_synagogue.glb',
        'texturePath': 'assets/textures/jewish_synagogue.jpg',
        'metadata': {
          'era': 'Jewish Heritage',
          'year': '1568',
          'style': 'Jewish Architecture',
          'materials': ['Granite', 'Wood', 'Gold'],
        },
        'scale': 0.4,
        'position': [0, 0, -2],
        'rotation': [0, 0, 0],
      },
    ];

    for (final modelData in defaultModels) {
      final model = ARModel.fromJson(modelData);
      _models[model.id] = model;
    }
  }

  Future<void> _loadCustomModels() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final customModelsDir = Directory('${appDir.path}/ar_models');
      
      if (await customModelsDir.exists()) {
        final files = customModelsDir.listSync();
        for (final file in files) {
          if (file.path.endsWith('.json')) {
            final content = await File(file.path).readAsString();
            final modelData = json.decode(content);
            final model = ARModel.fromJson(modelData);
            _models[model.id] = model;
          }
        }
      }
    } catch (e) {
      print('Failed to load custom models: $e');
    }
  }

  Future<ARModel?> getModel(String id) async {
    if (!_isInitialized) await initialize();
    return _models[id];
  }

  Future<List<ARModel>> getAllModels() async {
    if (!_isInitialized) await initialize();
    return _models.values.toList();
  }

  Future<List<ARModel>> getModelsByEra(String era) async {
    if (!_isInitialized) await initialize();
    return _models.values
        .where((model) => model.metadata['era'] == era)
        .toList();
  }

  Future<List<ARModel>> getModelsByStyle(String style) async {
    if (!_isInitialized) await initialize();
    return _models.values
        .where((model) => model.metadata['style'] == style)
        .toList();
  }

  Future<void> addCustomModel(ARModel model) async {
    _models[model.id] = model;
    
    // Save to local storage
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final customModelsDir = Directory('${appDir.path}/ar_models');
      if (!await customModelsDir.exists()) {
        await customModelsDir.create(recursive: true);
      }
      
      final modelFile = File('${customModelsDir.path}/${model.id}.json');
      await modelFile.writeAsString(json.encode(model.toJson()));
    } catch (e) {
      print('Failed to save custom model: $e');
    }
  }

  Future<void> removeCustomModel(String id) async {
    if (_models.containsKey(id)) {
      _models.remove(id);
      
      // Remove from local storage
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final modelFile = File('${appDir.path}/ar_models/$id.json');
        if (await modelFile.exists()) {
          await modelFile.delete();
        }
      } catch (e) {
        print('Failed to remove custom model: $e');
      }
    }
  }

  Future<bool> isModelLoaded(String id) async {
    return _loadedModels.containsKey(id);
  }

  Future<void> preloadModel(String id) async {
    if (_loadedModels.containsKey(id)) return;

    final model = _models[id];
    if (model == null) return;

    try {
      // Simulate model loading (in real implementation, this would load 3D models)
      await Future.delayed(Duration(milliseconds: 500));
      _loadedModels[id] = {
        'model': model,
        'loadedAt': DateTime.now(),
        'memoryUsage': 1024 * 1024, // 1MB placeholder
      };
    } catch (e) {
      print('Failed to preload model $id: $e');
    }
  }

  Future<void> unloadModel(String id) async {
    _loadedModels.remove(id);
  }

  Future<void> clearCache() async {
    _loadedModels.clear();
  }

  Map<String, dynamic> getModelStats() {
    return {
      'totalModels': _models.length,
      'loadedModels': _loadedModels.length,
      'memoryUsage': _loadedModels.values
          .fold<int>(0, (sum, model) => sum + (model['memoryUsage'] as int)),
      'cacheSize': _loadedModels.length,
    };
  }
}
