class UserModel {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final UserPreferences preferences;
  final UserStats stats;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.phoneNumber,
    required this.createdAt,
    required this.lastLoginAt,
    required this.preferences,
    required this.stats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      preferences: UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'preferences': preferences.toJson(),
      'stats': stats.toJson(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserPreferences? preferences,
    UserStats? stats,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
    );
  }
}

class UserPreferences {
  final String language;
  final String theme;
  final bool notificationsEnabled;
  final bool locationTrackingEnabled;
  final bool arSubtitlesEnabled;
  final String preferredTravelerType;
  final List<String> interests;

  UserPreferences({
    required this.language,
    required this.theme,
    required this.notificationsEnabled,
    required this.locationTrackingEnabled,
    required this.arSubtitlesEnabled,
    required this.preferredTravelerType,
    required this.interests,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] as String,
      theme: json['theme'] as String,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      locationTrackingEnabled: json['locationTrackingEnabled'] as bool,
      arSubtitlesEnabled: json['arSubtitlesEnabled'] as bool,
      preferredTravelerType: json['preferredTravelerType'] as String,
      interests: List<String>.from(json['interests'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme': theme,
      'notificationsEnabled': notificationsEnabled,
      'locationTrackingEnabled': locationTrackingEnabled,
      'arSubtitlesEnabled': arSubtitlesEnabled,
      'preferredTravelerType': preferredTravelerType,
      'interests': interests,
    };
  }

  UserPreferences copyWith({
    String? language,
    String? theme,
    bool? notificationsEnabled,
    bool? locationTrackingEnabled,
    bool? arSubtitlesEnabled,
    String? preferredTravelerType,
    List<String>? interests,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationTrackingEnabled: locationTrackingEnabled ?? this.locationTrackingEnabled,
      arSubtitlesEnabled: arSubtitlesEnabled ?? this.arSubtitlesEnabled,
      preferredTravelerType: preferredTravelerType ?? this.preferredTravelerType,
      interests: interests ?? this.interests,
    );
  }
}

class UserStats {
  final int sitesVisited;
  final int photosCaptured;
  final int arExperiences;
  final int socialShares;
  final int totalDistanceTraveled;
  final int badgesEarned;
  final List<String> achievements;

  UserStats({
    required this.sitesVisited,
    required this.photosCaptured,
    required this.arExperiences,
    required this.socialShares,
    required this.totalDistanceTraveled,
    required this.badgesEarned,
    required this.achievements,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      sitesVisited: json['sitesVisited'] as int,
      photosCaptured: json['photosCaptured'] as int,
      arExperiences: json['arExperiences'] as int,
      socialShares: json['socialShares'] as int,
      totalDistanceTraveled: json['totalDistanceTraveled'] as int,
      badgesEarned: json['badgesEarned'] as int,
      achievements: List<String>.from(json['achievements'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sitesVisited': sitesVisited,
      'photosCaptured': photosCaptured,
      'arExperiences': arExperiences,
      'socialShares': socialShares,
      'totalDistanceTraveled': totalDistanceTraveled,
      'badgesEarned': badgesEarned,
      'achievements': achievements,
    };
  }

  UserStats copyWith({
    int? sitesVisited,
    int? photosCaptured,
    int? arExperiences,
    int? socialShares,
    int? totalDistanceTraveled,
    int? badgesEarned,
    List<String>? achievements,
  }) {
    return UserStats(
      sitesVisited: sitesVisited ?? this.sitesVisited,
      photosCaptured: photosCaptured ?? this.photosCaptured,
      arExperiences: arExperiences ?? this.arExperiences,
      socialShares: socialShares ?? this.socialShares,
      totalDistanceTraveled: totalDistanceTraveled ?? this.totalDistanceTraveled,
      badgesEarned: badgesEarned ?? this.badgesEarned,
      achievements: achievements ?? this.achievements,
    );
  }
}
