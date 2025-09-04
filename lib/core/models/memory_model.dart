class MemoryModel {
  final String id;
  final String userId;
  final String siteId;
  final MemoryType type;
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final String? audioUrl;
  final String location;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final MemoryMetadata metadata;
  final MemoryEngagement engagement;
  final List<String> tags;
  final bool isPublic;
  final List<String> sharedWith;

  MemoryModel({
    required this.id,
    required this.userId,
    required this.siteId,
    required this.type,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    required this.location,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.updatedAt,
    required this.metadata,
    required this.engagement,
    required this.tags,
    required this.isPublic,
    required this.sharedWith,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      siteId: json['siteId'] as String,
      type: MemoryType.values.firstWhere(
        (e) => e.toString() == 'MemoryType.${json['type']}',
        orElse: () => MemoryType.photo,
      ),
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      location: json['location'] as String,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      metadata: MemoryMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      engagement: MemoryEngagement.fromJson(json['engagement'] as Map<String, dynamic>),
      tags: List<String>.from(json['tags'] as List),
      isPublic: json['isPublic'] as bool,
      sharedWith: List<String>.from(json['sharedWith'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'siteId': siteId,
      'type': type.toString().split('.').last,
      'content': content,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'metadata': metadata.toJson(),
      'engagement': engagement.toJson(),
      'tags': tags,
      'isPublic': isPublic,
      'sharedWith': sharedWith,
    };
  }

  MemoryModel copyWith({
    String? id,
    String? userId,
    String? siteId,
    MemoryType? type,
    String? content,
    String? imageUrl,
    String? videoUrl,
    String? audioUrl,
    String? location,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
    MemoryMetadata? metadata,
    MemoryEngagement? engagement,
    List<String>? tags,
    bool? isPublic,
    List<String>? sharedWith,
  }) {
    return MemoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      siteId: siteId ?? this.siteId,
      type: type ?? this.type,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
      engagement: engagement ?? this.engagement,
      tags: tags ?? this.tags,
      isPublic: isPublic ?? this.isPublic,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }
}

enum MemoryType {
  photo,
  video,
  audio,
  note,
  ar,
  mixed,
}

class MemoryMetadata {
  final int? width;
  final int? height;
  final int? duration; // in seconds
  final String? fileSize;
  final String? format;
  final Map<String, dynamic>? exifData;
  final String? deviceInfo;
  final String? appVersion;

  MemoryMetadata({
    this.width,
    this.height,
    this.duration,
    this.fileSize,
    this.format,
    this.exifData,
    this.deviceInfo,
    this.appVersion,
  });

  factory MemoryMetadata.fromJson(Map<String, dynamic> json) {
    return MemoryMetadata(
      width: json['width'] as int?,
      height: json['height'] as int?,
      duration: json['duration'] as int?,
      fileSize: json['fileSize'] as String?,
      format: json['format'] as String?,
      exifData: json['exifData'] != null ? Map<String, dynamic>.from(json['exifData'] as Map) : null,
      deviceInfo: json['deviceInfo'] as String?,
      appVersion: json['appVersion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'duration': duration,
      'fileSize': fileSize,
      'format': format,
      'exifData': exifData,
      'deviceInfo': deviceInfo,
      'appVersion': appVersion,
    };
  }
}

class MemoryEngagement {
  final int likes;
  final int comments;
  final int shares;
  final int views;
  final List<String> likedBy;
  final List<MemoryComment> commentsList;

  MemoryEngagement({
    required this.likes,
    required this.comments,
    required this.shares,
    required this.views,
    required this.likedBy,
    required this.commentsList,
  });

  factory MemoryEngagement.fromJson(Map<String, dynamic> json) {
    return MemoryEngagement(
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      shares: json['shares'] as int,
      views: json['views'] as int,
      likedBy: List<String>.from(json['likedBy'] as List),
      commentsList: (json['commentsList'] as List)
          .map((comment) => MemoryComment.fromJson(comment as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'views': views,
      'likedBy': likedBy,
      'commentsList': commentsList.map((comment) => comment.toJson()).toList(),
    };
  }

  MemoryEngagement copyWith({
    int? likes,
    int? comments,
    int? shares,
    int? views,
    List<String>? likedBy,
    List<MemoryComment>? commentsList,
  }) {
    return MemoryEngagement(
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      views: views ?? this.views,
      likedBy: likedBy ?? this.likedBy,
      commentsList: commentsList ?? this.commentsList,
    );
  }
}

class MemoryComment {
  final String id;
  final String userId;
  final String userName;
  final String? userProfileImage;
  final String content;
  final DateTime createdAt;
  final int likes;
  final List<String> likedBy;

  MemoryComment({
    required this.id,
    required this.userId,
    required this.userName,
    this.userProfileImage,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.likedBy,
  });

  factory MemoryComment.fromJson(Map<String, dynamic> json) {
    return MemoryComment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userProfileImage: json['userProfileImage'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: json['likes'] as int,
      likedBy: List<String>.from(json['likedBy'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'likedBy': likedBy,
    };
  }
}
