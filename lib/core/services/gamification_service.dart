import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class Achievement {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final int pointsReward;
  final String category;
  final String? requirement;
  final int requirementCount;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.pointsReward,
    required this.category,
    this.requirement,
    required this.requirementCount,
    required this.isUnlocked,
    this.unlockedAt,
    required this.progress,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconPath: json['iconPath'],
      pointsReward: json['pointsReward'],
      category: json['category'],
      requirement: json['requirement'],
      requirementCount: json['requirementCount'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'pointsReward': pointsReward,
      'category': category,
      'requirement': requirement,
      'requirementCount': requirementCount,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'progress': progress,
    };
  }

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    int? pointsReward,
    String? category,
    String? requirement,
    int? requirementCount,
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      pointsReward: pointsReward ?? this.pointsReward,
      category: category ?? this.category,
      requirement: requirement ?? this.requirement,
      requirementCount: requirementCount ?? this.requirementCount,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
    );
  }
}

class Badge {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final String category;
  final int rarity; // 1-5 (1=common, 5=legendary)
  final bool isEarned;
  final DateTime? earnedAt;
  final String? requirement;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.category,
    required this.rarity,
    required this.isEarned,
    this.earnedAt,
    this.requirement,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconPath: json['iconPath'],
      category: json['category'],
      rarity: json['rarity'],
      isEarned: json['isEarned'] ?? false,
      earnedAt: json['earnedAt'] != null ? DateTime.parse(json['earnedAt']) : null,
      requirement: json['requirement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'category': category,
      'rarity': rarity,
      'isEarned': isEarned,
      'earnedAt': earnedAt?.toIso8601String(),
      'requirement': requirement,
    };
  }
}

class Challenge {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final int pointsReward;
  final String category;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool isCompleted;
  final DateTime? completedAt;
  final Map<String, dynamic> requirements;
  final double progress;

  Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.pointsReward,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.isCompleted,
    this.completedAt,
    required this.requirements,
    required this.progress,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconPath: json['iconPath'],
      pointsReward: json['pointsReward'],
      category: json['category'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isActive: json['isActive'],
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      requirements: json['requirements'] ?? {},
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'pointsReward': pointsReward,
      'category': category,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'requirements': requirements,
      'progress': progress,
    };
  }
}

class LeaderboardEntry {
  final String userId;
  final String username;
  final String? profilePicture;
  final int points;
  final int rank;
  final int achievementsCount;
  final int badgesCount;
  final DateTime lastActivity;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    this.profilePicture,
    required this.points,
    required this.rank,
    required this.achievementsCount,
    required this.badgesCount,
    required this.lastActivity,
  });
}

class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  final Map<String, Achievement> _achievements = {};
  final Map<String, Badge> _badges = {};
  final Map<String, Challenge> _challenges = {};
  final Map<String, int> _userPoints = {};
  final Map<String, List<String>> _userAchievements = {};
  final Map<String, List<String>> _userBadges = {};
  final Map<String, List<String>> _userChallenges = {};
  final Map<String, Map<String, int>> _userProgress = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadAchievements();
      await _loadBadges();
      await _loadChallenges();
      await _loadFromStorage();
      _isInitialized = true;
    } catch (e) {
      print('Gamification service initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _loadAchievements() async {
    final achievements = [
      {
        'id': 'first_visit',
        'name': 'First Steps',
        'description': 'Visit your first heritage site',
        'iconPath': 'assets/icons/achievements/first_visit.png',
        'pointsReward': 50,
        'category': 'exploration',
        'requirement': 'heritage_sites_visited',
        'requirementCount': 1,
        'isUnlocked': false,
        'progress': 0.0,
      },
      {
        'id': 'photographer',
        'name': 'Memory Keeper',
        'description': 'Capture 10 photos at heritage sites',
        'iconPath': 'assets/icons/achievements/photographer.png',
        'pointsReward': 100,
        'category': 'media',
        'requirement': 'photos_captured',
        'requirementCount': 10,
        'isUnlocked': false,
        'progress': 0.0,
      },
      {
        'id': 'ar_explorer',
        'name': 'AR Pioneer',
        'description': 'Experience 5 AR models',
        'iconPath': 'assets/icons/achievements/ar_explorer.png',
        'pointsReward': 150,
        'category': 'technology',
        'requirement': 'ar_models_experienced',
        'requirementCount': 5,
        'isUnlocked': false,
        'progress': 0.0,
      },
      {
        'id': 'cultural_expert',
        'name': 'Cultural Expert',
        'description': 'Visit 20 different heritage sites',
        'iconPath': 'assets/icons/achievements/cultural_expert.png',
        'pointsReward': 300,
        'category': 'exploration',
        'requirement': 'heritage_sites_visited',
        'requirementCount': 20,
        'isUnlocked': false,
        'progress': 0.0,
      },
      {
        'id': 'social_butterfly',
        'name': 'Social Butterfly',
        'description': 'Share 25 memories',
        'iconPath': 'assets/icons/achievements/social_butterfly.png',
        'pointsReward': 200,
        'category': 'social',
        'requirement': 'memories_shared',
        'requirementCount': 25,
        'isUnlocked': false,
        'progress': 0.0,
      },
      {
        'id': 'weekly_explorer',
        'name': 'Weekly Explorer',
        'description': 'Visit heritage sites for 7 consecutive days',
        'iconPath': 'assets/icons/achievements/weekly_explorer.png',
        'pointsReward': 250,
        'category': 'consistency',
        'requirement': 'consecutive_days',
        'requirementCount': 7,
        'isUnlocked': false,
        'progress': 0.0,
      },
    ];

    for (final achievementData in achievements) {
      final achievement = Achievement.fromJson(achievementData);
      _achievements[achievement.id] = achievement;
    }
  }

  Future<void> _loadBadges() async {
    final badges = [
      {
        'id': 'kochi_explorer',
        'name': 'Kochi Explorer',
        'description': 'Explore 5 sites in Kochi',
        'iconPath': 'assets/icons/badges/kochi_explorer.png',
        'category': 'location',
        'rarity': 2,
        'isEarned': false,
        'requirement': 'Visit 5 heritage sites in Kochi',
      },
      {
        'id': 'portuguese_heritage',
        'name': 'Portuguese Heritage',
        'description': 'Visit all Portuguese colonial sites',
        'iconPath': 'assets/icons/badges/portuguese_heritage.png',
        'category': 'heritage',
        'rarity': 4,
        'isEarned': false,
        'requirement': 'Visit all Portuguese colonial heritage sites',
      },
      {
        'id': 'early_bird',
        'name': 'Early Bird',
        'description': 'Visit sites before 9 AM',
        'iconPath': 'assets/icons/badges/early_bird.png',
        'category': 'time',
        'rarity': 3,
        'isEarned': false,
        'requirement': 'Visit heritage sites before 9 AM',
      },
      {
        'id': 'night_owl',
        'name': 'Night Owl',
        'description': 'Visit sites after 6 PM',
        'iconPath': 'assets/icons/badges/night_owl.png',
        'category': 'time',
        'rarity': 3,
        'isEarned': false,
        'requirement': 'Visit heritage sites after 6 PM',
      },
      {
        'id': 'rainy_day_explorer',
        'name': 'Rainy Day Explorer',
        'description': 'Visit sites during monsoon',
        'iconPath': 'assets/icons/badges/rainy_day_explorer.png',
        'category': 'weather',
        'rarity': 4,
        'isEarned': false,
        'requirement': 'Visit heritage sites during monsoon season',
      },
    ];

    for (final badgeData in badges) {
      final badge = Badge.fromJson(badgeData);
      _badges[badge.id] = badge;
    }
  }

  Future<void> _loadChallenges() async {
    final now = DateTime.now();
    final challenges = [
      {
        'id': 'heritage_marathon',
        'name': 'Heritage Marathon',
        'description': 'Visit 10 heritage sites in one week',
        'iconPath': 'assets/icons/challenges/heritage_marathon.png',
        'pointsReward': 500,
        'category': 'exploration',
        'startDate': now.subtract(Duration(days: 1)).toIso8601String(),
        'endDate': now.add(Duration(days: 6)).toIso8601String(),
        'isActive': true,
        'isCompleted': false,
        'requirements': {'heritage_sites_visited': 10, 'timeframe_days': 7},
        'progress': 0.0,
      },
      {
        'id': 'cultural_photographer',
        'name': 'Cultural Photographer',
        'description': 'Capture photos at 15 different heritage sites',
        'iconPath': 'assets/icons/challenges/cultural_photographer.png',
        'pointsReward': 400,
        'category': 'media',
        'startDate': now.subtract(Duration(days: 3)).toIso8601String(),
        'endDate': now.add(Duration(days: 27)).toIso8601String(),
        'isActive': true,
        'isCompleted': false,
        'requirements': {'sites_with_photos': 15, 'timeframe_days': 30},
        'progress': 0.0,
      },
      {
        'id': 'ar_master',
        'name': 'AR Master',
        'description': 'Experience all available AR models',
        'iconPath': 'assets/icons/challenges/ar_master.png',
        'pointsReward': 600,
        'category': 'technology',
        'startDate': now.subtract(Duration(days: 5)).toIso8601String(),
        'endDate': now.add(Duration(days: 25)).toIso8601String(),
        'isActive': true,
        'isCompleted': false,
        'requirements': {'ar_models_experienced': 10},
        'progress': 0.0,
      },
    ];

    for (final challengeData in challenges) {
      final challenge = Challenge.fromJson(challengeData);
      _challenges[challenge.id] = challenge;
    }
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load user points
      final pointsJson = prefs.getString('user_points');
      if (pointsJson != null) {
        final points = json.decode(pointsJson) as Map<String, dynamic>;
        for (final entry in points.entries) {
          _userPoints[entry.key] = entry.value as int;
        }
      }

      // Load user achievements
      final achievementsJson = prefs.getString('user_achievements');
      if (achievementsJson != null) {
        final achievements = json.decode(achievementsJson) as Map<String, dynamic>;
        for (final entry in achievements.entries) {
          _userAchievements[entry.key] = List<String>.from(entry.value);
        }
      }

      // Load user badges
      final badgesJson = prefs.getString('user_badges');
      if (badgesJson != null) {
        final badges = json.decode(badgesJson) as Map<String, dynamic>;
        for (final entry in badges.entries) {
          _userBadges[entry.key] = List<String>.from(entry.value);
        }
      }

      // Load user challenges
      final challengesJson = prefs.getString('user_challenges');
      if (challengesJson != null) {
        final challenges = json.decode(challengesJson) as Map<String, dynamic>;
        for (final entry in challenges.entries) {
          _userChallenges[entry.key] = List<String>.from(entry.value);
        }
      }

      // Load user progress
      final progressJson = prefs.getString('user_progress');
      if (progressJson != null) {
        final progress = json.decode(progressJson) as Map<String, dynamic>;
        for (final entry in progress.entries) {
          final progressMap = <String, int>{};
          for (final progressEntry in (entry.value as Map<String, dynamic>).entries) {
            progressMap[progressEntry.key] = progressEntry.value as int;
          }
          _userProgress[entry.key] = progressMap;
        }
      }
    } catch (e) {
      print('Failed to load gamification data from storage: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save user points
      final pointsJson = json.encode(_userPoints);
      await prefs.setString('user_points', pointsJson);

      // Save user achievements
      final achievementsJson = json.encode(_userAchievements);
      await prefs.setString('user_achievements', achievementsJson);

      // Save user badges
      final badgesJson = json.encode(_userBadges);
      await prefs.setString('user_badges', badgesJson);

      // Save user challenges
      final challengesJson = json.encode(_userChallenges);
      await prefs.setString('user_challenges', challengesJson);

      // Save user progress
      final progressJson = json.encode(_userProgress);
      await prefs.setString('user_progress', progressJson);
    } catch (e) {
      print('Failed to save gamification data to storage: $e');
    }
  }

  // Points System
  Future<int> getUserPoints(String userId) async {
    if (!_isInitialized) await initialize();
    return _userPoints[userId] ?? 0;
  }

  Future<void> addPoints(String userId, int points, String reason) async {
    if (!_isInitialized) await initialize();

    _userPoints[userId] = (_userPoints[userId] ?? 0) + points;
    await _saveToStorage();

    // Check for achievements
    await _checkAchievements(userId);
  }

  Future<void> deductPoints(String userId, int points, String reason) async {
    if (!_isInitialized) await initialize();

    final currentPoints = _userPoints[userId] ?? 0;
    _userPoints[userId] = (currentPoints - points).clamp(0, double.infinity).toInt();
    await _saveToStorage();
  }

  // Achievement System
  Future<List<Achievement>> getUserAchievements(String userId) async {
    if (!_isInitialized) await initialize();

    final userAchievementIds = _userAchievements[userId] ?? [];
    return userAchievementIds
        .map((id) => _achievements[id])
        .where((achievement) => achievement != null)
        .cast<Achievement>()
        .toList();
  }

  Future<List<Achievement>> getAllAchievements() async {
    if (!_isInitialized) await initialize();
    return _achievements.values.toList();
  }

  Future<void> _checkAchievements(String userId) async {
    final progress = _userProgress[userId] ?? {};
    
    for (final achievement in _achievements.values) {
      if (achievement.isUnlocked) continue;

      final requirement = achievement.requirement;
      if (requirement != null) {
        final currentCount = progress[requirement] ?? 0;
        final progressValue = (currentCount / achievement.requirementCount).clamp(0.0, 1.0);
        
        // Update progress
        _achievements[achievement.id] = achievement.copyWith(progress: progressValue);
        
        // Check if unlocked
        if (currentCount >= achievement.requirementCount) {
          await _unlockAchievement(userId, achievement.id);
        }
      }
    }
  }

  Future<void> _unlockAchievement(String userId, String achievementId) async {
    final achievement = _achievements[achievementId];
    if (achievement == null || achievement.isUnlocked) return;

    // Mark as unlocked
    _achievements[achievementId] = achievement.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
      progress: 1.0,
    );

    // Add to user achievements
    if (!_userAchievements.containsKey(userId)) {
      _userAchievements[userId] = [];
    }
    _userAchievements[userId]!.add(achievementId);

    // Award points
    await addPoints(userId, achievement.pointsReward, 'Achievement: ${achievement.name}');

    await _saveToStorage();
  }

  // Badge System
  Future<List<Badge>> getUserBadges(String userId) async {
    if (!_isInitialized) await initialize();

    final userBadgeIds = _userBadges[userId] ?? [];
    return userBadgeIds
        .map((id) => _badges[id])
        .where((badge) => badge != null)
        .cast<Badge>()
        .toList();
  }

  Future<List<Badge>> getAllBadges() async {
    if (!_isInitialized) await initialize();
    return _badges.values.toList();
  }

  Future<void> awardBadge(String userId, String badgeId) async {
    if (!_isInitialized) await initialize();

    final badge = _badges[badgeId];
    if (badge == null) return;

    // Check if already earned
    if (!_userBadges.containsKey(userId)) {
      _userBadges[userId] = [];
    }
    
    if (!_userBadges[userId]!.contains(badgeId)) {
      _userBadges[userId]!.add(badgeId);
      
      // Mark as earned
      _badges[badgeId] = badge.copyWith(
        isEarned: true,
        earnedAt: DateTime.now(),
      );

      await _saveToStorage();
    }
  }

  // Challenge System
  Future<List<Challenge>> getUserChallenges(String userId) async {
    if (!_isInitialized) await initialize();

    final userChallengeIds = _userChallenges[userId] ?? [];
    return userChallengeIds
        .map((id) => _challenges[id])
        .where((challenge) => challenge != null)
        .cast<Challenge>()
        .toList();
  }

  Future<List<Challenge>> getActiveChallenges() async {
    if (!_isInitialized) await initialize();
    
    final now = DateTime.now();
    return _challenges.values
        .where((challenge) => challenge.isActive && 
                              challenge.startDate.isBefore(now) && 
                              challenge.endDate.isAfter(now))
        .toList();
  }

  Future<void> updateChallengeProgress(String userId, String challengeId, Map<String, int> progress) async {
    if (!_isInitialized) await initialize();

    final challenge = _challenges[challengeId];
    if (challenge == null || challenge.isCompleted) return;

    // Update user progress
    if (!_userProgress.containsKey(userId)) {
      _userProgress[userId] = {};
    }
    
    for (final entry in progress.entries) {
      _userProgress[userId]![entry.key] = (_userProgress[userId]![entry.key] ?? 0) + entry.value;
    }

    // Check if challenge is completed
    bool isCompleted = true;
    double totalProgress = 0.0;
    int totalRequirements = 0;

    for (final requirement in challenge.requirements.entries) {
      final currentCount = _userProgress[userId]![requirement.key] ?? 0;
      final requiredCount = requirement.value;
      
      if (currentCount < requiredCount) {
        isCompleted = false;
      }
      
      totalProgress += (currentCount / requiredCount).clamp(0.0, 1.0);
      totalRequirements++;
    }

    final averageProgress = totalProgress / totalRequirements;

    if (isCompleted && !challenge.isCompleted) {
      // Complete challenge
      _challenges[challengeId] = challenge.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        progress: 1.0,
      );

      // Add to user challenges
      if (!_userChallenges.containsKey(userId)) {
        _userChallenges[userId] = [];
      }
      _userChallenges[userId]!.add(challengeId);

      // Award points
      await addPoints(userId, challenge.pointsReward, 'Challenge: ${challenge.name}');
    } else {
      // Update progress
      _challenges[challengeId] = challenge.copyWith(progress: averageProgress);
    }

    await _saveToStorage();
  }

  // Leaderboard System
  Future<List<LeaderboardEntry>> getLeaderboard({int limit = 50}) async {
    if (!_isInitialized) await initialize();

    final entries = <LeaderboardEntry>[];
    final sortedUsers = _userPoints.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (int i = 0; i < limit && i < sortedUsers.length; i++) {
      final entry = sortedUsers[i];
      final userId = entry.key;
      final points = entry.value;
      
      final achievementsCount = _userAchievements[userId]?.length ?? 0;
      final badgesCount = _userBadges[userId]?.length ?? 0;
      
      // Mock user data (in real app, this would come from user service)
      final username = 'User_${userId.substring(0, 4)}';
      final profilePicture = null;
      final lastActivity = DateTime.now().subtract(Duration(hours: Random().nextInt(24)));

      entries.add(LeaderboardEntry(
        userId: userId,
        username: username,
        profilePicture: profilePicture,
        points: points,
        rank: i + 1,
        achievementsCount: achievementsCount,
        badgesCount: badgesCount,
        lastActivity: lastActivity,
      ));
    }

    return entries;
  }

  // Progress Tracking
  Future<Map<String, int>> getUserProgress(String userId) async {
    if (!_isInitialized) await initialize();
    return _userProgress[userId] ?? {};
  }

  Future<void> updateProgress(String userId, String metric, int value) async {
    if (!_isInitialized) await initialize();

    if (!_userProgress.containsKey(userId)) {
      _userProgress[userId] = {};
    }
    
    _userProgress[userId]![metric] = (_userProgress[userId]![metric] ?? 0) + value;
    
    await _saveToStorage();
    await _checkAchievements(userId);
  }

  // Analytics
  Future<Map<String, dynamic>> getGamificationAnalytics(String userId) async {
    if (!_isInitialized) await initialize();

    final points = _userPoints[userId] ?? 0;
    final achievements = _userAchievements[userId]?.length ?? 0;
    final badges = _userBadges[userId]?.length ?? 0;
    final challenges = _userChallenges[userId]?.length ?? 0;
    final progress = _userProgress[userId] ?? {};

    return {
      'totalPoints': points,
      'achievementsUnlocked': achievements,
      'badgesEarned': badges,
      'challengesCompleted': challenges,
      'totalAchievements': _achievements.length,
      'totalBadges': _badges.length,
      'totalChallenges': _challenges.length,
      'achievementProgress': (achievements / _achievements.length * 100).toStringAsFixed(1),
      'badgeProgress': (badges / _badges.length * 100).toStringAsFixed(1),
      'recentActivity': progress,
    };
  }
}
