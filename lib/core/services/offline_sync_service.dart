import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';
import 'database_service.dart';

class OfflineRequest {
  final String id;
  final String method; // GET/POST/PUT/DELETE (mostly write ops queued)
  final String path;
  final Map<String, dynamic>? body;
  final Map<String, String>? headers;
  final DateTime createdAt;

  OfflineRequest({
    required this.id,
    required this.method,
    required this.path,
    this.body,
    this.headers,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'method': method,
        'path': path,
        'body': body,
        'headers': headers,
        'createdAt': createdAt.toIso8601String(),
      };

  factory OfflineRequest.fromJson(Map<String, dynamic> json) => OfflineRequest(
        id: json['id'] as String,
        method: json['method'] as String,
        path: json['path'] as String,
        body: (json['body'] as Map?)?.cast<String, dynamic>(),
        headers: (json['headers'] as Map?)?.cast<String, String>(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class OfflineSyncService {
  static final OfflineSyncService _instance = OfflineSyncService._internal();
  factory OfflineSyncService() => _instance;
  OfflineSyncService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connSub;

  late final ApiService _api;
  late final DatabaseService _db;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Keys
  static const String _kCacheHeritageSites = 'cache_heritage_sites';
  static const String _kCacheMemories = 'cache_memories';
  static const String _kSyncQueue = 'sync_queue';
  static const String _kLastSync = 'last_sync';

  Future<void> initialize({required ApiService api, required DatabaseService db}) async {
    if (_isInitialized) return;
    _api = api;
    _db = db;

    // Start listening to connectivity changes
    _connSub = _connectivity.onConnectivityChanged.listen((status) async {
      if (status != ConnectivityResult.none) {
        await processQueue();
        await syncContent();
      }
    });

    _isInitialized = true;
  }

  Future<void> dispose() async {
    await _connSub?.cancel();
  }

  // Cache content locally
  Future<void> cacheHeritageSites(List<Map<String, dynamic>> sites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCacheHeritageSites, jsonEncode(sites));
  }

  Future<List<Map<String, dynamic>>> getCachedHeritageSites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kCacheHeritageSites);
    if (raw == null) return [];
    final List list = jsonDecode(raw) as List;
    return list.cast<Map>().map((e) => e.cast<String, dynamic>()).toList();
  }

  Future<void> cacheMemories(List<Map<String, dynamic>> memories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCacheMemories, jsonEncode(memories));
  }

  Future<List<Map<String, dynamic>>> getCachedMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kCacheMemories);
    if (raw == null) return [];
    final List list = jsonDecode(raw) as List;
    return list.cast<Map>().map((e) => e.cast<String, dynamic>()).toList();
  }

  // Queue write operation when offline
  Future<void> enqueueRequest(OfflineRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kSyncQueue);
    final List<OfflineRequest> queue = raw == null
        ? []
        : (jsonDecode(raw) as List)
            .cast<Map>()
            .map((e) => OfflineRequest.fromJson(e.cast<String, dynamic>()))
            .toList();

    queue.add(request);
    await prefs.setString(_kSyncQueue, jsonEncode(queue.map((e) => e.toJson()).toList()));
  }

  Future<List<OfflineRequest>> _getQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kSyncQueue);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .cast<Map>()
        .map((e) => OfflineRequest.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<void> _saveQueue(List<OfflineRequest> queue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSyncQueue, jsonEncode(queue.map((e) => e.toJson()).toList()));
  }

  Future<bool> _isOnline() async {
    final status = await _connectivity.checkConnectivity();
    return status != ConnectivityResult.none;
  }

  // Process queued write ops
  Future<void> processQueue() async {
    if (!await _isOnline()) return;

    final queue = await _getQueue();
    if (queue.isEmpty) return;

    final remaining = <OfflineRequest>[];

    for (final req in queue) {
      try {
        switch (req.method.toUpperCase()) {
          case 'POST':
            await _api.post(req.path, data: req.body, headers: req.headers);
            break;
          case 'PUT':
            await _api.put(req.path, data: req.body, headers: req.headers);
            break;
          case 'DELETE':
            await _api.delete(req.path, headers: req.headers);
            break;
          default:
            // GET is not queued usually
            break;
        }
      } catch (_) {
        // Keep in queue if failed
        remaining.add(req);
      }
    }

    await _saveQueue(remaining);
  }

  // Sync fresh content down when online
  Future<void> syncContent() async {
    if (!await _isOnline()) return;
    try {
      // Example pulls (adjust to actual endpoints in ApiService)
      final sitesResp = await _api.get('/heritage-sites');
      final sites = (sitesResp.data as List).cast<Map>().map((e) => e.cast<String, dynamic>()).toList();
      await cacheHeritageSites(sites);

      final memoriesResp = await _api.get('/memories');
      final memories = (memoriesResp.data as List).cast<Map>().map((e) => e.cast<String, dynamic>()).toList();
      await cacheMemories(memories);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLastSync, DateTime.now().toIso8601String());
    } catch (e) {
      // Silently ignore, will try next time
    }
  }

  Future<String?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLastSync);
  }

  // Prepare offline AR models by copying bundled assets to app storage if needed
  Future<void> prepareOfflineARAssets(List<Map<String, String>> models) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final modelsDir = Directory('${dir.path}/ar_models_assets');
      if (!await modelsDir.exists()) {
        await modelsDir.create(recursive: true);
      }

      for (final m in models) {
        final assetPath = m['assetPath'];
        final id = m['id'];
        if (assetPath == null || id == null) continue;

        final file = File('${modelsDir.path}/$id.glb');
        if (!await file.exists()) {
          final bytes = await rootBundle.load(assetPath);
          await file.writeAsBytes(bytes.buffer.asUint8List());
        }
      }
    } catch (_) {
      // Best-effort; ignore failures
    }
  }
}
