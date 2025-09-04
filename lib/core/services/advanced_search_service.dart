import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';

class SearchFilter {
  final String? era;
  final String? architectureStyle;
  final String? culturalTheme;
  final double? minRating;
  final double? maxDistance;
  final List<String>? tags;
  final bool? isAccessible;
  final bool? hasARExperience;
  final String? bestTimeToVisit;
  final double? maxEntranceFee;

  SearchFilter({
    this.era,
    this.architectureStyle,
    this.culturalTheme,
    this.minRating,
    this.maxDistance,
    this.tags,
    this.isAccessible,
    this.hasARExperience,
    this.bestTimeToVisit,
    this.maxEntranceFee,
  });

  Map<String, dynamic> toJson() {
    return {
      'era': era,
      'architectureStyle': architectureStyle,
      'culturalTheme': culturalTheme,
      'minRating': minRating,
      'maxDistance': maxDistance,
      'tags': tags,
      'isAccessible': isAccessible,
      'hasARExperience': hasARExperience,
      'bestTimeToVisit': bestTimeToVisit,
      'maxEntranceFee': maxEntranceFee,
    };
  }

  factory SearchFilter.fromJson(Map<String, dynamic> json) {
    return SearchFilter(
      era: json['era'],
      architectureStyle: json['architectureStyle'],
      culturalTheme: json['culturalTheme'],
      minRating: json['minRating']?.toDouble(),
      maxDistance: json['maxDistance']?.toDouble(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      isAccessible: json['isAccessible'],
      hasARExperience: json['hasARExperience'],
      bestTimeToVisit: json['bestTimeToVisit'],
      maxEntranceFee: json['maxEntranceFee']?.toDouble(),
    );
  }
}

class SearchResult {
  final String id;
  final String name;
  final String description;
  final double relevanceScore;
  final double distance;
  final double rating;
  final List<String> matchedTags;
  final Map<String, dynamic> metadata;

  SearchResult({
    required this.id,
    required this.name,
    required this.description,
    required this.relevanceScore,
    required this.distance,
    required this.rating,
    required this.matchedTags,
    required this.metadata,
  });
}

class SearchSuggestion {
  final String text;
  final String type; // 'heritage_site', 'era', 'style', 'theme'
  final double confidence;
  final Map<String, dynamic> context;

  SearchSuggestion({
    required this.text,
    required this.type,
    required this.confidence,
    required this.context,
  });
}

class AdvancedSearchService {
  static final AdvancedSearchService _instance = AdvancedSearchService._internal();
  factory AdvancedSearchService() => _instance;
  AdvancedSearchService._internal();

  final Map<String, List<String>> _searchIndex = {};
  final Map<String, Map<String, dynamic>> _heritageData = {};
  final Map<String, double> _popularityScores = {};
  bool _isInitialized = false;

  // Search patterns and synonyms
  final Map<String, List<String>> _searchSynonyms = {
    'fort': ['castle', 'fortress', 'citadel', 'stronghold'],
    'palace': ['royal', 'king', 'queen', 'maharaja', 'maharani'],
    'temple': ['mandir', 'kovil', 'devasthanam', 'sanctuary'],
    'church': ['cathedral', 'basilica', 'chapel', 'sanctuary'],
    'mosque': ['masjid', 'jama', 'dargah', 'shrine'],
    'synagogue': ['jewish', 'hebrew', 'temple', 'shul'],
    'museum': ['gallery', 'exhibition', 'collection', 'archive'],
    'ancient': ['old', 'historic', 'antique', 'vintage', 'classical'],
    'colonial': ['european', 'portuguese', 'dutch', 'british', 'french'],
    'traditional': ['classical', 'heritage', 'indigenous', 'native'],
    'kochi': ['cochin', 'kochi', 'cochi', 'kerala'],
    'mattancherry': ['mattancherry', 'jewish town', 'jew town'],
  };

  // Cultural themes and their keywords
  final Map<String, List<String>> _culturalThemes = {
    'portuguese_heritage': ['portugal', 'colonial', 'european', 'christian', 'catholic'],
    'dutch_influence': ['dutch', 'netherlands', 'east india company', 'trading'],
    'british_colonial': ['british', 'england', 'victorian', 'colonial', 'empire'],
    'traditional_kerala': ['kerala', 'malayalam', 'ayurveda', 'backwaters', 'spices'],
    'jewish_heritage': ['jewish', 'hebrew', 'synagogue', 'jew', 'paradesi'],
    'islamic_culture': ['islamic', 'muslim', 'mosque', 'arabic', 'moorish'],
    'hindu_tradition': ['hindu', 'temple', 'deity', 'puja', 'vedic'],
  };

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _buildSearchIndex();
      await _loadPopularityData();
      _isInitialized = true;
    } catch (e) {
      print('Advanced search service initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _buildSearchIndex() async {
    // Build search index from heritage site data
    final heritageSites = await _getMockHeritageData();
    
    for (final site in heritageSites) {
      final id = site['id'] as String;
      _heritageData[id] = site;
      
      // Index by name
      _addToIndex(id, site['name'] as String, 'name');
      
      // Index by description
      _addToIndex(id, site['description'] as String, 'description');
      
      // Index by tags
      final tags = site['tags'] as List<dynamic>?;
      if (tags != null) {
        for (final tag in tags) {
          _addToIndex(id, tag as String, 'tag');
        }
      }
      
      // Index by era
      final era = site['era'] as String?;
      if (era != null) {
        _addToIndex(id, era, 'era');
      }
      
      // Index by architecture style
      final style = site['architectureStyle'] as String?;
      if (style != null) {
        _addToIndex(id, style, 'style');
      }
    }
  }

  void _addToIndex(String id, String text, String type) {
    final words = text.toLowerCase().split(RegExp(r'\s+'));
    
    for (final word in words) {
      final cleanWord = word.replaceAll(RegExp(r'[^\w]'), '');
      if (cleanWord.length > 2) {
        if (!_searchIndex.containsKey(cleanWord)) {
          _searchIndex[cleanWord] = [];
        }
        if (!_searchIndex[cleanWord]!.contains(id)) {
          _searchIndex[cleanWord]!.add(id);
        }
      }
    }
  }

  Future<void> _loadPopularityData() async {
    // Simulate loading popularity scores from analytics
    final sites = _heritageData.keys.toList();
    final random = Random();
    
    for (final siteId in sites) {
      _popularityScores[siteId] = random.nextDouble() * 100;
    }
  }

  Future<List<SearchResult>> search(String query, {SearchFilter? filter}) async {
    if (!_isInitialized) await initialize();

    final queryLower = query.toLowerCase().trim();
    if (queryLower.isEmpty) return [];

    // Split query into words
    final queryWords = queryLower.split(RegExp(r'\s+'));
    
    // Find matching sites
    final Set<String> matchingSites = {};
    final Map<String, int> siteMatchCounts = {};
    
    for (final word in queryWords) {
      final cleanWord = word.replaceAll(RegExp(r'[^\w]'), '');
      if (cleanWord.length > 2) {
        // Direct matches
        if (_searchIndex.containsKey(cleanWord)) {
          for (final siteId in _searchIndex[cleanWord]!) {
            matchingSites.add(siteId);
            siteMatchCounts[siteId] = (siteMatchCounts[siteId] ?? 0) + 1;
          }
        }
        
        // Synonym matches
        for (final entry in _searchSynonyms.entries) {
          if (entry.value.contains(cleanWord) || entry.key == cleanWord) {
            for (final synonym in entry.value) {
              if (_searchIndex.containsKey(synonym)) {
                for (final siteId in _searchIndex[synonym]!) {
                  matchingSites.add(siteId);
                  siteMatchCounts[siteId] = (siteMatchCounts[siteId] ?? 0) + 1;
                }
              }
            }
          }
        }
      }
    }

    // Convert to search results
    final results = <SearchResult>[];
    for (final siteId in matchingSites) {
      final site = _heritageData[siteId];
      if (site != null) {
        final result = _createSearchResult(siteId, site, siteMatchCounts[siteId] ?? 0);
        
        // Apply filters if provided
        if (filter == null || _passesFilter(result, filter)) {
          results.add(result);
        }
      }
    }

    // Sort by relevance score
    results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    
    return results;
  }

  SearchResult _createSearchResult(String id, Map<String, dynamic> site, int matchCount) {
    final name = site['name'] as String;
    final description = site['description'] as String;
    final rating = (site['rating'] as num?)?.toDouble() ?? 0.0;
    final distance = (site['distance'] as num?)?.toDouble() ?? 0.0;
    
    // Calculate relevance score based on multiple factors
    final textRelevance = matchCount / 10.0; // Normalize match count
    final ratingRelevance = rating / 5.0; // Normalize rating
    final popularityRelevance = (_popularityScores[id] ?? 0) / 100.0; // Normalize popularity
    final distanceRelevance = distance > 0 ? 1.0 / (1.0 + distance / 10.0) : 1.0; // Distance penalty
    
    final relevanceScore = (textRelevance * 0.4 + 
                           ratingRelevance * 0.3 + 
                           popularityRelevance * 0.2 + 
                           distanceRelevance * 0.1);
    
    // Extract matched tags
    final matchedTags = <String>[];
    final tags = site['tags'] as List<dynamic>? ?? [];
    for (final tag in tags) {
      if (tag.toString().toLowerCase().contains(name.toLowerCase())) {
        matchedTags.add(tag.toString());
      }
    }
    
    return SearchResult(
      id: id,
      name: name,
      description: description,
      relevanceScore: relevanceScore,
      distance: distance,
      rating: rating,
      matchedTags: matchedTags,
      metadata: site,
    );
  }

  bool _passesFilter(SearchResult result, SearchFilter filter) {
    if (filter.era != null && result.metadata['era'] != filter.era) return false;
    if (filter.architectureStyle != null && result.metadata['architectureStyle'] != filter.architectureStyle) return false;
    if (filter.culturalTheme != null && result.metadata['culturalTheme'] != filter.culturalTheme) return false;
    if (filter.minRating != null && result.rating < filter.minRating!) return false;
    if (filter.maxDistance != null && result.distance > filter.maxDistance!) return false;
    if (filter.maxEntranceFee != null && (result.metadata['entranceFee'] ?? 0) > filter.maxEntranceFee!) return false;
    if (filter.isAccessible != null && result.metadata['isAccessible'] != filter.isAccessible) return false;
    if (filter.hasARExperience != null && result.metadata['hasARExperience'] != filter.hasARExperience) return false;
    
    if (filter.tags != null && filter.tags!.isNotEmpty) {
      final hasMatchingTag = filter.tags!.any((tag) => 
        result.matchedTags.any((resultTag) => 
          resultTag.toLowerCase().contains(tag.toLowerCase())
        )
      );
      if (!hasMatchingTag) return false;
    }
    
    return true;
  }

  Future<List<SearchSuggestion>> getSearchSuggestions(String partialQuery) async {
    if (!_isInitialized) await initialize();

    final suggestions = <SearchSuggestion>[];
    final queryLower = partialQuery.toLowerCase().trim();
    
    if (queryLower.isEmpty) return suggestions;

    // Direct matches from search index
    for (final entry in _searchIndex.entries) {
      if (entry.key.startsWith(queryLower) || entry.key.contains(queryLower)) {
        final siteIds = entry.value;
        if (siteIds.isNotEmpty) {
          final firstSite = _heritageData[siteIds.first];
          if (firstSite != null) {
            suggestions.add(SearchSuggestion(
              text: entry.key,
              type: 'heritage_site',
              confidence: 0.8,
              context: {'siteId': siteIds.first, 'siteName': firstSite['name']},
            ));
          }
        }
      }
    }

    // Cultural theme suggestions
    for (final entry in _culturalThemes.entries) {
      if (entry.key.contains(queryLower) || 
          entry.value.any((keyword) => keyword.contains(queryLower))) {
        suggestions.add(SearchSuggestion(
          text: entry.key.replaceAll('_', ' ').toUpperCase(),
          type: 'cultural_theme',
          confidence: 0.7,
          context: {'theme': entry.key, 'keywords': entry.value},
        ));
      }
    }

    // Era suggestions
    final eras = ['ancient', 'medieval', 'colonial', 'modern', 'contemporary'];
    for (final era in eras) {
      if (era.contains(queryLower)) {
        suggestions.add(SearchSuggestion(
          text: era.toUpperCase(),
          type: 'era',
          confidence: 0.6,
          context: {'era': era},
        ));
      }
    }

    // Sort by confidence and limit results
    suggestions.sort((a, b) => b.confidence.compareTo(a.confidence));
    return suggestions.take(10).toList();
  }

  Future<List<SearchResult>> getPersonalizedRecommendations(String userId, {int limit = 10}) async {
    if (!_isInitialized) await initialize();

    // Simulate personalized recommendations based on user preferences
    final recommendations = <SearchResult>[];
    final sites = _heritageData.values.toList();
    
    // Sort by popularity and rating for now
    sites.sort((a, b) {
      final aScore = (_popularityScores[a['id']] ?? 0) + ((a['rating'] ?? 0) * 10);
      final bScore = (_popularityScores[b['id']] ?? 0) + ((b['rating'] ?? 0) * 10);
      return bScore.compareTo(aScore);
    });
    
    for (int i = 0; i < limit && i < sites.length; i++) {
      final site = sites[i];
      final result = _createSearchResult(site['id'], site, 1);
      recommendations.add(result);
    }
    
    return recommendations;
  }

  Future<List<SearchResult>> getTrendingSites({int limit = 10}) async {
    if (!_isInitialized) await initialize();

    final trending = <SearchResult>[];
    final sortedSites = _popularityScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (int i = 0; i < limit && i < sortedSites.length; i++) {
      final siteId = sortedSites[i].key;
      final site = _heritageData[siteId];
      if (site != null) {
        final result = _createSearchResult(siteId, site, 1);
        trending.add(result);
      }
    }
    
    return trending;
  }

  Future<Map<String, dynamic>> getSearchAnalytics() async {
    if (!_isInitialized) await initialize();

    return {
      'totalSites': _heritageData.length,
      'indexedWords': _searchIndex.length,
      'popularSites': _popularityScores.entries
          .toList()
          .take(5)
          .map((e) => {'id': e.key, 'score': e.value})
          .toList(),
      'searchCategories': {
        'heritage_sites': _heritageData.length,
        'cultural_themes': _culturalThemes.length,
        'eras': 5, // ancient, medieval, colonial, modern, contemporary
        'architecture_styles': 8, // estimated
      },
    };
  }

  Future<List<Map<String, dynamic>>> _getMockHeritageData() async {
    // Simulate loading heritage site data
    return [
      {
        'id': 'fort_kochi',
        'name': 'Fort Kochi',
        'description': 'Historic Portuguese colonial fortress with rich maritime history',
        'era': 'colonial',
        'architectureStyle': 'european_fortress',
        'culturalTheme': 'portuguese_heritage',
        'rating': 4.5,
        'distance': 2.1,
        'entranceFee': 50,
        'isAccessible': true,
        'hasARExperience': true,
        'tags': ['fort', 'colonial', 'portuguese', 'maritime', 'kochi'],
      },
      {
        'id': 'mattancherry_palace',
        'name': 'Mattancherry Palace',
        'description': 'Traditional Kerala palace with Portuguese and Dutch influences',
        'era': 'colonial',
        'architectureStyle': 'traditional_kerala',
        'culturalTheme': 'traditional_kerala',
        'rating': 4.3,
        'distance': 3.2,
        'entranceFee': 30,
        'isAccessible': true,
        'hasARExperience': true,
        'tags': ['palace', 'traditional', 'kerala', 'colonial', 'architecture'],
      },
      {
        'id': 'jewish_synagogue',
        'name': 'Paradesi Synagogue',
        'description': 'Ancient Jewish synagogue with beautiful architecture and history',
        'era': 'ancient',
        'architectureStyle': 'jewish_architecture',
        'culturalTheme': 'jewish_heritage',
        'rating': 4.7,
        'distance': 2.8,
        'entranceFee': 25,
        'isAccessible': true,
        'hasARExperience': false,
        'tags': ['synagogue', 'jewish', 'ancient', 'religious', 'architecture'],
      },
    ];
  }
}
