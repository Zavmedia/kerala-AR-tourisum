import 'dart:async';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class VoiceSearchResult {
  final String query;
  final String recognizedText;
  final double confidence;
  final List<String> suggestions;
  final DateTime timestamp;

  VoiceSearchResult({
    required this.query,
    required this.recognizedText,
    required this.confidence,
    required this.suggestions,
    required this.timestamp,
  });
}

class VoiceSearchService {
  static final VoiceSearchService _instance = VoiceSearchService._internal();
  factory VoiceSearchService() => _instance;
  VoiceSearchService._internal();

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  StreamController<VoiceSearchResult>? _resultController;
  StreamController<String>? _statusController;

  // Heritage site keywords for better recognition
  final List<String> _heritageKeywords = [
    'fort', 'palace', 'temple', 'church', 'mosque', 'synagogue',
    'museum', 'monument', 'heritage', 'historical', 'ancient',
    'kochi', 'kerala', 'mattancherry', 'jewish', 'portuguese',
    'dutch', 'british', 'colonial', 'architecture', 'culture',
    'visit', 'explore', 'see', 'show', 'find', 'search',
    'nearby', 'popular', 'famous', 'beautiful', 'amazing',
  ];

  // Common search patterns
  final Map<String, List<String>> _searchPatterns = {
    'location_based': ['near me', 'nearby', 'around here', 'close by'],
    'era_based': ['ancient', 'medieval', 'colonial', 'modern'],
    'type_based': ['fort', 'palace', 'temple', 'church', 'museum'],
    'feature_based': ['beautiful', 'famous', 'popular', 'historical'],
    'action_based': ['visit', 'explore', 'see', 'show', 'find'],
  };

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        print('Microphone permission denied');
        return false;
      }

      // Initialize speech recognition
      final available = await _speechToText.initialize(
        onError: (error) {
          print('Speech recognition error: $error');
          _statusController?.add('Error: ${error.errorMsg}');
        },
        onStatus: (status) {
          print('Speech recognition status: $status');
          _statusController?.add(status);
        },
      );

      _isInitialized = available;
      return available;
    } catch (e) {
      print('Voice search initialization failed: $e');
      return false;
    }
  }

  Future<void> startListening() async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    if (_isListening) return;

    try {
      _isListening = true;
      _statusController?.add('Listening...');

      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            _processSpeechResult(result.recognizedWords);
          }
        },
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 3),
        partialResults: true,
        localeId: 'en_US', // Can be extended for multiple languages
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
    } catch (e) {
      print('Failed to start listening: $e');
      _statusController?.add('Failed to start listening');
      _isListening = false;
    }
  }

  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await _speechToText.stop();
      _isListening = false;
      _statusController?.add('Stopped listening');
    } catch (e) {
      print('Failed to stop listening: $e');
    }
  }

  void _processSpeechResult(String recognizedText) {
    if (recognizedText.isEmpty) return;

    final query = recognizedText.toLowerCase().trim();
    final confidence = _calculateConfidence(query);
    final suggestions = _generateSuggestions(query);

    final result = VoiceSearchResult(
      query: query,
      recognizedText: recognizedText,
      confidence: confidence,
      suggestions: suggestions,
      timestamp: DateTime.now(),
    );

    _resultController?.add(result);
    _statusController?.add('Recognized: $recognizedText');
  }

  double _calculateConfidence(String query) {
    if (query.isEmpty) return 0.0;

    int keywordMatches = 0;
    for (final keyword in _heritageKeywords) {
      if (query.contains(keyword)) {
        keywordMatches++;
      }
    }

    // Base confidence on keyword matches and query length
    final keywordConfidence = keywordMatches / _heritageKeywords.length;
    final lengthConfidence = query.length / 100; // Normalize by expected length
    
    return (keywordConfidence * 0.7 + lengthConfidence * 0.3).clamp(0.0, 1.0);
  }

  List<String> _generateSuggestions(String query) {
    final suggestions = <String>[];
    
    // Add heritage site suggestions based on recognized keywords
    if (query.contains('fort')) {
      suggestions.addAll(['Fort Kochi', 'Fort Emmanuel', 'Fort Vypin']);
    }
    if (query.contains('palace')) {
      suggestions.addAll(['Mattancherry Palace', 'Bolghatty Palace', 'Hill Palace']);
    }
    if (query.contains('temple')) {
      suggestions.addAll(['Sree Poornathrayeesa Temple', 'Ernakulam Shiva Temple']);
    }
    if (query.contains('church')) {
      suggestions.addAll(['St. Francis Church', 'Santa Cruz Basilica']);
    }
    if (query.contains('synagogue')) {
      suggestions.addAll(['Paradesi Synagogue', 'Kadavumbhagam Synagogue']);
    }

    // Add location-based suggestions
    if (query.contains('near') || query.contains('nearby')) {
      suggestions.addAll(['Nearby Heritage Sites', 'Popular in Your Area']);
    }

    // Add era-based suggestions
    if (query.contains('ancient')) {
      suggestions.addAll(['Ancient Temples', 'Historical Monuments']);
    }
    if (query.contains('colonial')) {
      suggestions.addAll(['Colonial Architecture', 'Portuguese Heritage']);
    }

    return suggestions.take(5).toList(); // Limit to 5 suggestions
  }

  Future<List<String>> searchHeritageSites(String query) async {
    // Simulate heritage site search based on voice query
    final results = <String>[];
    
    if (query.contains('kochi') || query.contains('fort')) {
      results.addAll([
        'Fort Kochi - Portuguese Colonial Fortress',
        'Mattancherry Palace - Traditional Kerala Architecture',
        'Jewish Synagogue - Historic Jewish Heritage Site',
      ]);
    }
    
    if (query.contains('temple') || query.contains('ancient')) {
      results.addAll([
        'Sree Poornathrayeesa Temple - Ancient Hindu Temple',
        'Ernakulam Shiva Temple - Sacred Shiva Shrine',
      ]);
    }
    
    if (query.contains('church') || query.contains('colonial')) {
      results.addAll([
        'St. Francis Church - Oldest European Church in India',
        'Santa Cruz Basilica - Portuguese Catholic Church',
      ]);
    }

    return results;
  }

  Stream<VoiceSearchResult> get resultStream {
    _resultController ??= StreamController<VoiceSearchResult>.broadcast();
    return _resultController!.stream;
  }

  Stream<String> get statusStream {
    _statusController ??= StreamController<String>.broadcast();
    return _statusController!.stream;
  }

  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;

  Future<void> dispose() async {
    await stopListening();
    await _resultController?.close();
    await _statusController?.close();
  }

  // Utility method to check if query is heritage-related
  bool isHeritageQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return _heritageKeywords.any((keyword) => lowerQuery.contains(keyword));
  }

  // Get search suggestions for UI
  List<String> getSearchSuggestions(String partialQuery) {
    if (partialQuery.isEmpty) return [];
    
    final suggestions = <String>[];
    final lowerQuery = partialQuery.toLowerCase();
    
    for (final keyword in _heritageKeywords) {
      if (keyword.startsWith(lowerQuery) || lowerQuery.contains(keyword)) {
        suggestions.add(keyword);
      }
    }
    
    return suggestions.take(10).toList();
  }
}
