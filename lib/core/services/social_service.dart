import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String id;
  final String username;
  final String email;
  final String? profilePicture;
  final String? bio;
  final String? location;
  final List<String> interests;
  final Map<String, dynamic> preferences;
  final int followersCount;
  final int followingCount;
  final int memoriesCount;
  final DateTime joinedDate;
  final bool isVerified;
  final String? website;
  final List<String> socialLinks;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.profilePicture,
    this.bio,
    this.location,
    required this.interests,
    required this.preferences,
    required this.followersCount,
    required this.followingCount,
    required this.memoriesCount,
    required this.joinedDate,
    required this.isVerified,
    this.website,
    required this.socialLinks,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      bio: json['bio'],
      location: json['location'],
      interests: List<String>.from(json['interests'] ?? []),
      preferences: json['preferences'] ?? {},
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      memoriesCount: json['memoriesCount'] ?? 0,
      joinedDate: DateTime.parse(json['joinedDate']),
      isVerified: json['isVerified'] ?? false,
      website: json['website'],
      socialLinks: List<String>.from(json['socialLinks'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
      'bio': bio,
      'location': location,
      'interests': interests,
      'preferences': preferences,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'memoriesCount': memoriesCount,
      'joinedDate': joinedDate.toIso8601String(),
      'isVerified': isVerified,
      'website': website,
      'socialLinks': socialLinks,
    };
  }

  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    String? profilePicture,
    String? bio,
    String? location,
    List<String>? interests,
    Map<String, dynamic>? preferences,
    int? followersCount,
    int? followingCount,
    int? memoriesCount,
    DateTime? joinedDate,
    bool? isVerified,
    String? website,
    List<String>? socialLinks,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      preferences: preferences ?? this.preferences,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      memoriesCount: memoriesCount ?? this.memoriesCount,
      joinedDate: joinedDate ?? this.joinedDate,
      isVerified: isVerified ?? this.isVerified,
      website: website ?? this.website,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }
}

class Comment {
  final String id;
  final String userId;
  final String username;
  final String? userProfilePicture;
  final String content;
  final DateTime timestamp;
  final int likesCount;
  final List<String> likedBy;
  final List<Comment> replies;
  final String? parentCommentId;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    this.userProfilePicture,
    required this.content,
    required this.timestamp,
    required this.likesCount,
    required this.likedBy,
    required this.replies,
    this.parentCommentId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      userProfilePicture: json['userProfilePicture'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      likesCount: json['likesCount'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      replies: (json['replies'] as List<dynamic>?)
          ?.map((reply) => Comment.fromJson(reply))
          .toList() ?? [],
      parentCommentId: json['parentCommentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userProfilePicture': userProfilePicture,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'likesCount': likesCount,
      'likedBy': likedBy,
      'replies': replies.map((reply) => reply.toJson()).toList(),
      'parentCommentId': parentCommentId,
    };
  }
}

class SocialInteraction {
  final String id;
  final String type; // 'like', 'comment', 'share', 'follow'
  final String userId;
  final String targetId; // memory id, user id, etc.
  final String targetType; // 'memory', 'user', 'comment'
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  SocialInteraction({
    required this.id,
    required this.type,
    required this.userId,
    required this.targetId,
    required this.targetType,
    required this.timestamp,
    required this.metadata,
  });

  factory SocialInteraction.fromJson(Map<String, dynamic> json) {
    return SocialInteraction(
      id: json['id'],
      type: json['type'],
      userId: json['userId'],
      targetId: json['targetId'],
      targetType: json['targetType'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'userId': userId,
      'targetId': targetId,
      'targetType': targetType,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

class SocialService {
  static final SocialService _instance = SocialService._internal();
  factory SocialService() => _instance;
  SocialService._internal();

  final Map<String, UserProfile> _userProfiles = {};
  final Map<String, List<String>> _followers = {};
  final Map<String, List<String>> _following = {};
  final Map<String, List<Comment>> _memoryComments = {};
  final Map<String, List<String>> _memoryLikes = {};
  final Map<String, List<SocialInteraction>> _socialInteractions = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadMockData();
      await _loadFromStorage();
      _isInitialized = true;
    } catch (e) {
      print('Social service initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _loadMockData() async {
    // Create mock user profiles
    final mockUsers = [
      {
        'id': 'user1',
        'username': 'heritage_explorer',
        'email': 'explorer@example.com',
        'profilePicture': 'https://example.com/profile1.jpg',
        'bio': 'Passionate about exploring historical sites and sharing memories',
        'location': 'Kochi, Kerala',
        'interests': ['heritage', 'photography', 'travel', 'history'],
        'preferences': {'language': 'en', 'theme': 'light'},
        'followersCount': 1250,
        'followingCount': 89,
        'memoriesCount': 45,
        'joinedDate': '2023-01-15T00:00:00.000Z',
        'isVerified': true,
        'website': 'https://heritage-explorer.com',
        'socialLinks': ['@heritage_explorer'],
      },
      {
        'id': 'user2',
        'username': 'kerala_culture',
        'email': 'culture@example.com',
        'profilePicture': 'https://example.com/profile2.jpg',
        'bio': 'Celebrating the rich culture and heritage of Kerala',
        'location': 'Thiruvananthapuram, Kerala',
        'interests': ['kerala_culture', 'traditional_arts', 'festivals'],
        'preferences': {'language': 'ml', 'theme': 'dark'},
        'followersCount': 890,
        'followingCount': 156,
        'memoriesCount': 32,
        'joinedDate': '2023-03-20T00:00:00.000Z',
        'isVerified': false,
        'website': null,
        'socialLinks': ['@kerala_culture'],
      },
    ];

    for (final userData in mockUsers) {
      final profile = UserProfile.fromJson(userData);
      _userProfiles[profile.id] = profile;
    }

    // Initialize follow relationships
    _followers['user1'] = ['user2'];
    _following['user1'] = ['user2'];
    _followers['user2'] = ['user1'];
    _following['user2'] = ['user1'];

    // Initialize memory interactions
    _memoryComments['memory1'] = [
      Comment(
        id: 'comment1',
        userId: 'user2',
        username: 'kerala_culture',
        userProfilePicture: 'https://example.com/profile2.jpg',
        content: 'Beautiful capture! The architecture is stunning.',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        likesCount: 3,
        likedBy: ['user1'],
        replies: [],
        parentCommentId: null,
      ),
    ];

    _memoryLikes['memory1'] = ['user1', 'user2'];
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load user profiles
      final profilesJson = prefs.getString('user_profiles');
      if (profilesJson != null) {
        final profiles = json.decode(profilesJson) as Map<String, dynamic>;
        for (final entry in profiles.entries) {
          _userProfiles[entry.key] = UserProfile.fromJson(entry.value);
        }
      }

      // Load follow relationships
      final followersJson = prefs.getString('followers');
      if (followersJson != null) {
        final followers = json.decode(followersJson) as Map<String, dynamic>;
        for (final entry in followers.entries) {
          _followers[entry.key] = List<String>.from(entry.value);
        }
      }

      final followingJson = prefs.getString('following');
      if (followingJson != null) {
        final following = json.decode(followingJson) as Map<String, dynamic>;
        for (final entry in following.entries) {
          _following[entry.key] = List<String>.from(entry.value);
        }
      }
    } catch (e) {
      print('Failed to load social data from storage: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save user profiles
      final profilesJson = json.encode(_userProfiles.map(
        (key, value) => MapEntry(key, value.toJson()),
      ));
      await prefs.setString('user_profiles', profilesJson);

      // Save follow relationships
      final followersJson = json.encode(_followers);
      await prefs.setString('followers', followersJson);

      final followingJson = json.encode(_following);
      await prefs.setString('following', followingJson);
    } catch (e) {
      print('Failed to save social data to storage: $e');
    }
  }

  // User Profile Management
  Future<UserProfile?> getUserProfile(String userId) async {
    if (!_isInitialized) await initialize();
    return _userProfiles[userId];
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    if (!_isInitialized) await initialize();

    final profile = _userProfiles[userId];
    if (profile != null) {
      final updatedProfile = profile.copyWith(
        bio: updates['bio'] ?? profile.bio,
        location: updates['location'] ?? profile.location,
        interests: updates['interests'] ?? profile.interests,
        preferences: updates['preferences'] ?? profile.preferences,
        website: updates['website'] ?? profile.website,
        socialLinks: updates['socialLinks'] ?? profile.socialLinks,
      );
      
      _userProfiles[userId] = updatedProfile;
      await _saveToStorage();
    }
  }

  Future<void> updateProfilePicture(String userId, String pictureUrl) async {
    if (!_isInitialized) await initialize();

    final profile = _userProfiles[userId];
    if (profile != null) {
      final updatedProfile = profile.copyWith(profilePicture: pictureUrl);
      _userProfiles[userId] = updatedProfile;
      await _saveToStorage();
    }
  }

  // Follow System
  Future<bool> followUser(String followerId, String targetUserId) async {
    if (!_isInitialized) await initialize();
    if (followerId == targetUserId) return false;

    // Add to following list
    if (!_following.containsKey(followerId)) {
      _following[followerId] = [];
    }
    if (!_following[followerId]!.contains(targetUserId)) {
      _following[followerId]!.add(targetUserId);
    }

    // Add to followers list
    if (!_followers.containsKey(targetUserId)) {
      _followers[targetUserId] = [];
    }
    if (!_followers[targetUserId]!.contains(followerId)) {
      _followers[targetUserId]!.add(followerId);
    }

    // Update counts
    final followerProfile = _userProfiles[followerId];
    final targetProfile = _userProfiles[targetUserId];
    
    if (followerProfile != null) {
      _userProfiles[followerId] = followerProfile.copyWith(
        followingCount: _following[followerId]!.length,
      );
    }
    
    if (targetProfile != null) {
      _userProfiles[targetUserId] = targetProfile.copyWith(
        followersCount: _followers[targetUserId]!.length,
      );
    }

    // Record interaction
    final interaction = SocialInteraction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'follow',
      userId: followerId,
      targetId: targetUserId,
      targetType: 'user',
      timestamp: DateTime.now(),
      metadata: {},
    );
    
    if (!_socialInteractions.containsKey(followerId)) {
      _socialInteractions[followerId] = [];
    }
    _socialInteractions[followerId]!.add(interaction);

    await _saveToStorage();
    return true;
  }

  Future<bool> unfollowUser(String followerId, String targetUserId) async {
    if (!_isInitialized) await initialize();

    // Remove from following list
    _following[followerId]?.remove(targetUserId);

    // Remove from followers list
    _followers[targetUserId]?.remove(followerId);

    // Update counts
    final followerProfile = _userProfiles[followerId];
    final targetProfile = _userProfiles[targetUserId];
    
    if (followerProfile != null) {
      _userProfiles[followerId] = followerProfile.copyWith(
        followingCount: _following[followerId]?.length ?? 0,
      );
    }
    
    if (targetProfile != null) {
      _userProfiles[targetUserId] = targetProfile.copyWith(
        followersCount: _followers[targetUserId]?.length ?? 0,
      );
    }

    await _saveToStorage();
    return true;
  }

  Future<bool> isFollowing(String followerId, String targetUserId) async {
    if (!_isInitialized) await initialize();
    return _following[followerId]?.contains(targetUserId) ?? false;
  }

  Future<List<String>> getFollowers(String userId) async {
    if (!_isInitialized) await initialize();
    return _followers[userId] ?? [];
  }

  Future<List<String>> getFollowing(String userId) async {
    if (!_isInitialized) await initialize();
    return _following[userId] ?? [];
  }

  // Comments System
  Future<Comment> addComment(String memoryId, String userId, String content, {String? parentCommentId}) async {
    if (!_isInitialized) await initialize();

    final userProfile = _userProfiles[userId];
    if (userProfile == null) {
      throw Exception('User profile not found');
    }

    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      username: userProfile.username,
      userProfilePicture: userProfile.profilePicture,
      content: content,
      timestamp: DateTime.now(),
      likesCount: 0,
      likedBy: [],
      replies: [],
      parentCommentId: parentCommentId,
    );

    if (!_memoryComments.containsKey(memoryId)) {
      _memoryComments[memoryId] = [];
    }
    _memoryComments[memoryId]!.add(comment);

    // Record interaction
    final interaction = SocialInteraction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'comment',
      userId: userId,
      targetId: memoryId,
      targetType: 'memory',
      timestamp: DateTime.now(),
      metadata: {'commentId': comment.id, 'content': content},
    );
    
    if (!_socialInteractions.containsKey(userId)) {
      _socialInteractions[userId] = [];
    }
    _socialInteractions[userId]!.add(interaction);

    return comment;
  }

  Future<List<Comment>> getComments(String memoryId) async {
    if (!_isInitialized) await initialize();
    return _memoryComments[memoryId] ?? [];
  }

  Future<void> deleteComment(String memoryId, String commentId) async {
    if (!_isInitialized) await initialize();

    final comments = _memoryComments[memoryId];
    if (comments != null) {
      comments.removeWhere((comment) => comment.id == commentId);
    }
  }

  // Likes System
  Future<bool> likeMemory(String memoryId, String userId) async {
    if (!_isInitialized) await initialize();

    if (!_memoryLikes.containsKey(memoryId)) {
      _memoryLikes[memoryId] = [];
    }

    if (!_memoryLikes[memoryId]!.contains(userId)) {
      _memoryLikes[memoryId]!.add(userId);

      // Record interaction
      final interaction = SocialInteraction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'like',
        userId: userId,
        targetId: memoryId,
        targetType: 'memory',
        timestamp: DateTime.now(),
        metadata: {},
      );
      
      if (!_socialInteractions.containsKey(userId)) {
        _socialInteractions[userId] = [];
      }
      _socialInteractions[userId]!.add(interaction);

      return true;
    }
    return false;
  }

  Future<bool> unlikeMemory(String memoryId, String userId) async {
    if (!_isInitialized) await initialize();

    final likes = _memoryLikes[memoryId];
    if (likes != null) {
      return likes.remove(userId);
    }
    return false;
  }

  Future<bool> isLiked(String memoryId, String userId) async {
    if (!_isInitialized) await initialize();
    return _memoryLikes[memoryId]?.contains(userId) ?? false;
  }

  Future<int> getLikesCount(String memoryId) async {
    if (!_isInitialized) await initialize();
    return _memoryLikes[memoryId]?.length ?? 0;
  }

  // Social Feed
  Future<List<SocialInteraction>> getUserFeed(String userId, {int limit = 20}) async {
    if (!_isInitialized) await initialize();

    final following = _following[userId] ?? [];
    final feed = <SocialInteraction>[];

    for (final followedUserId in following) {
      final interactions = _socialInteractions[followedUserId] ?? [];
      feed.addAll(interactions);
    }

    // Sort by timestamp (newest first)
    feed.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return feed.take(limit).toList();
  }

  Future<List<UserProfile>> getSuggestedUsers(String userId, {int limit = 10}) async {
    if (!_isInitialized) await initialize();

    final following = _following[userId] ?? [];
    final suggested = <UserProfile>[];

    for (final profile in _userProfiles.values) {
      if (profile.id != userId && !following.contains(profile.id)) {
        suggested.add(profile);
      }
    }

    // Sort by followers count (most popular first)
    suggested.sort((a, b) => b.followersCount.compareTo(a.followersCount));
    
    return suggested.take(limit).toList();
  }

  // Analytics
  Future<Map<String, dynamic>> getSocialAnalytics(String userId) async {
    if (!_isInitialized) await initialize();

    final profile = _userProfiles[userId];
    if (profile == null) return {};

    final interactions = _socialInteractions[userId] ?? [];
    final likesGiven = interactions.where((i) => i.type == 'like').length;
    final commentsGiven = interactions.where((i) => i.type == 'comment').length;

    return {
      'followersCount': profile.followersCount,
      'followingCount': profile.followingCount,
      'memoriesCount': profile.memoriesCount,
      'likesGiven': likesGiven,
      'commentsGiven': commentsGiven,
      'engagementRate': profile.followersCount > 0 
          ? ((likesGiven + commentsGiven) / profile.followersCount * 100).toStringAsFixed(2)
          : '0.00',
    };
  }
}
