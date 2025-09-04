import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/user_model.dart';
import '../models/heritage_site_model.dart';
import '../models/memory_model.dart';

class DatabaseService {
  static const String _userKey = 'current_user';
  static const String _heritageSitesKey = 'heritage_sites';
  static const String _memoriesKey = 'memories';
  static const String _favoritesKey = 'favorite_sites';
  static const String _offlineDataKey = 'offline_data';
  static const String _lastSyncKey = 'last_sync';

  late SharedPreferences _prefs;
  late Directory _appDirectory;

  DatabaseService._();
  static final DatabaseService _instance = DatabaseService._();
  static DatabaseService get instance => _instance;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _appDirectory = await getApplicationDocumentsDirectory();
  }

  // User Management
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  Future<UserModel?> getCurrentUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }

  // Heritage Sites Management
  Future<void> saveHeritageSites(List<HeritageSiteModel> sites) async {
    final sitesJson = sites.map((site) => site.toJson()).toList();
    await _prefs.setString(_heritageSitesKey, jsonEncode(sitesJson));
  }

  Future<List<HeritageSiteModel>> getHeritageSites() async {
    final sitesJson = _prefs.getString(_heritageSitesKey);
    if (sitesJson != null) {
      try {
        final sitesList = jsonDecode(sitesJson) as List<dynamic>;
        return sitesList.map((site) => HeritageSiteModel.fromJson(site as Map<String, dynamic>)).toList();
      } catch (e) {
        print('Error parsing heritage sites: $e');
        return [];
      }
    }
    return [];
  }

  Future<HeritageSiteModel?> getHeritageSiteById(String siteId) async {
    final sites = await getHeritageSites();
    try {
      return sites.firstWhere((site) => site.id == siteId);
    } catch (e) {
      return null;
    }
  }

  Future<List<HeritageSiteModel>> getNearbySites(double latitude, double longitude, double radiusKm) async {
    final sites = await getHeritageSites();
    return sites.where((site) {
      final distance = site.calculateDistance(latitude, longitude);
      return distance <= radiusKm;
    }).toList();
  }

  Future<List<HeritageSiteModel>> searchHeritageSites(String query) async {
    final sites = await getHeritageSites();
    final lowerQuery = query.toLowerCase();
    
    return sites.where((site) {
      return site.name.toLowerCase().contains(lowerQuery) ||
             site.description.toLowerCase().contains(lowerQuery) ||
             site.category.toLowerCase().contains(lowerQuery) ||
             site.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Favorites Management
  Future<void> addToFavorites(String siteId) async {
    final favorites = await getFavoriteSiteIds();
    if (!favorites.contains(siteId)) {
      favorites.add(siteId);
      await _prefs.setStringList(_favoritesKey, favorites);
    }
  }

  Future<void> removeFromFavorites(String siteId) async {
    final favorites = await getFavoriteSiteIds();
    favorites.remove(siteId);
    await _prefs.setStringList(_favoritesKey, favorites);
  }

  Future<List<String>> getFavoriteSiteIds() async {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<List<HeritageSiteModel>> getFavoriteSites() async {
    final favoriteIds = await getFavoriteSiteIds();
    final sites = await getHeritageSites();
    return sites.where((site) => favoriteIds.contains(site.id)).toList();
  }

  Future<bool> isFavorite(String siteId) async {
    final favorites = await getFavoriteSiteIds();
    return favorites.contains(siteId);
  }

  // Memories Management
  Future<void> saveMemory(MemoryModel memory) async {
    final memories = await getMemories();
    final existingIndex = memories.indexWhere((m) => m.id == memory.id);
    
    if (existingIndex >= 0) {
      memories[existingIndex] = memory;
    } else {
      memories.add(memory);
    }
    
    await _saveMemories(memories);
  }

  Future<void> _saveMemories(List<MemoryModel> memories) async {
    final memoriesJson = memories.map((memory) => memory.toJson()).toList();
    await _prefs.setString(_memoriesKey, jsonEncode(memoriesJson));
  }

  Future<List<MemoryModel>> getMemories() async {
    final memoriesJson = _prefs.getString(_memoriesKey);
    if (memoriesJson != null) {
      try {
        final memoriesList = jsonDecode(memoriesJson) as List<dynamic>;
        return memoriesList.map((memory) => MemoryModel.fromJson(memory as Map<String, dynamic>)).toList();
      } catch (e) {
        print('Error parsing memories: $e');
        return [];
      }
    }
    return [];
  }

  Future<List<MemoryModel>> getMemoriesBySite(String siteId) async {
    final memories = await getMemories();
    return memories.where((memory) => memory.siteId == siteId).toList();
  }

  Future<List<MemoryModel>> getMemoriesByType(MemoryType type) async {
    final memories = await getMemories();
    return memories.where((memory) => memory.type == type).toList();
  }

  Future<List<MemoryModel>> searchMemories(String query) async {
    final memories = await getMemories();
    final lowerQuery = query.toLowerCase();
    
    return memories.where((memory) {
      return memory.content.toLowerCase().contains(lowerQuery) ||
             memory.location.toLowerCase().contains(lowerQuery) ||
             memory.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  Future<void> deleteMemory(String memoryId) async {
    final memories = await getMemories();
    memories.removeWhere((memory) => memory.id == memoryId);
    await _saveMemories(memories);
  }

  // Offline Data Management
  Future<void> saveOfflineData(Map<String, dynamic> data) async {
    await _prefs.setString(_offlineDataKey, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getOfflineData() async {
    final dataJson = _prefs.getString(_offlineDataKey);
    if (dataJson != null) {
      try {
        return jsonDecode(dataJson) as Map<String, dynamic>;
      } catch (e) {
        print('Error parsing offline data: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> clearOfflineData() async {
    await _prefs.remove(_offlineDataKey);
  }

  // Sync Management
  Future<void> updateLastSync(DateTime dateTime) async {
    await _prefs.setString(_lastSyncKey, dateTime.toIso8601String());
  }

  Future<DateTime?> getLastSync() async {
    final lastSyncString = _prefs.getString(_lastSyncKey);
    if (lastSyncString != null) {
      try {
        return DateTime.parse(lastSyncString);
      } catch (e) {
        print('Error parsing last sync date: $e');
        return null;
      }
    }
    return null;
  }

  // File Management
  Future<String> saveFileToLocal(File file, String fileName) async {
    final localFile = File('${_appDirectory.path}/$fileName');
    await file.copy(localFile.path);
    return localFile.path;
  }

  Future<File?> getLocalFile(String fileName) async {
    final file = File('${_appDirectory.path}/$fileName');
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  Future<void> deleteLocalFile(String fileName) async {
    final file = File('${_appDirectory.path}/$fileName');
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Cache Management
  Future<void> clearCache() async {
    await _prefs.clear();
    
    // Clear local files
    if (await _appDirectory.exists()) {
      await for (final entity in _appDirectory.list()) {
        if (entity is File) {
          await entity.delete();
        }
      }
    }
  }

  Future<int> getCacheSize() async {
    int totalSize = 0;
    
    if (await _appDirectory.exists()) {
      await for (final entity in _appDirectory.list()) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    }
    
    return totalSize;
  }

  // Data Export/Import
  Future<Map<String, dynamic>> exportUserData() async {
    final user = await getCurrentUser();
    final sites = await getHeritageSites();
    final memories = await getMemories();
    final favorites = await getFavoriteSiteIds();
    
    return {
      'user': user?.toJson(),
      'sites': sites.map((site) => site.toJson()).toList(),
      'memories': memories.map((memory) => memory.toJson()).toList(),
      'favorites': favorites,
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  Future<void> importUserData(Map<String, dynamic> data) async {
    try {
      if (data['user'] != null) {
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        await saveUser(user);
      }
      
      if (data['sites'] != null) {
        final sitesList = data['sites'] as List<dynamic>;
        final sites = sitesList.map((site) => HeritageSiteModel.fromJson(site as Map<String, dynamic>)).toList();
        await saveHeritageSites(sites);
      }
      
      if (data['memories'] != null) {
        final memoriesList = data['memories'] as List<dynamic>;
        final memories = memoriesList.map((memory) => MemoryModel.fromJson(memory as Map<String, dynamic>)).toList();
        await _saveMemories(memories);
      }
      
      if (data['favorites'] != null) {
        final favorites = List<String>.from(data['favorites'] as List);
        await _prefs.setStringList(_favoritesKey, favorites);
      }
    } catch (e) {
      print('Error importing user data: $e');
      throw Exception('Failed to import user data');
    }
  }

  // Statistics
  Future<Map<String, int>> getDataStatistics() async {
    final sites = await getHeritageSites();
    final memories = await getMemories();
    final favorites = await getFavoriteSiteIds();
    
    return {
      'totalSites': sites.length,
      'totalMemories': memories.length,
      'totalFavorites': favorites.length,
      'photoMemories': memories.where((m) => m.type == MemoryType.photo).length,
      'videoMemories': memories.where((m) => m.type == MemoryType.video).length,
      'arMemories': memories.where((m) => m.type == MemoryType.ar).length,
    };
  }
}
