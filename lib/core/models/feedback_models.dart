import 'dart:convert';

// Review Status
enum ReviewStatus {
  pending,
  published,
  flagged,
  removed,
  moderated,
}

// App Feedback Priority
enum FeedbackPriority {
  low,
  medium,
  high,
  critical,
}

// App Feedback Status
enum AppFeedbackStatus {
  open,
  inProgress,
  resolved,
  closed,
}

// Review
class Review {
  final String id;
  final String heritageSiteId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String title;
  final String content;
  final List<String> images;
  final List<String> tags;
  final ReviewStatus status;
  final int helpfulCount;
  final int unhelpfulCount;
  final bool isVerified;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.heritageSiteId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.title,
    required this.content,
    required this.images,
    required this.tags,
    required this.status,
    required this.helpfulCount,
    required this.unhelpfulCount,
    required this.isVerified,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      heritageSiteId: json['heritageSiteId'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      rating: (json['rating'] as num).toDouble(),
      title: json['title'],
      content: json['content'],
      images: List<String>.from(json['images'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      status: ReviewStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReviewStatus.pending,
      ),
      helpfulCount: json['helpfulCount'] ?? 0,
      unhelpfulCount: json['unhelpfulCount'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heritageSiteId': heritageSiteId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'title': title,
      'content': content,
      'images': images,
      'tags': tags,
      'status': status.name,
      'helpfulCount': helpfulCount,
      'unhelpfulCount': unhelpfulCount,
      'isVerified': isVerified,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// App Feedback
class AppFeedback {
  final String id;
  final String userId;
  final String userName;
  final String category;
  final String title;
  final String description;
  final FeedbackPriority priority;
  final AppFeedbackStatus status;
  final List<String> attachments;
  final String? assignedTo;
  final String? resolution;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;

  AppFeedback({
    required this.id,
    required this.userId,
    required this.userName,
    required this.category,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.attachments,
    this.assignedTo,
    this.resolution,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
  });

  factory AppFeedback.fromJson(Map<String, dynamic> json) {
    return AppFeedback(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      category: json['category'],
      title: json['title'],
      description: json['description'],
      priority: FeedbackPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => FeedbackPriority.medium,
      ),
      status: AppFeedbackStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AppFeedbackStatus.open,
      ),
      attachments: List<String>.from(json['attachments'] ?? []),
      assignedTo: json['assignedTo'],
      resolution: json['resolution'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'category': category,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'attachments': attachments,
      'assignedTo': assignedTo,
      'resolution': resolution,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }
}

// Feedback Analytics
class FeedbackAnalytics {
  final int totalReviews;
  final int totalAppFeedback;
  final double averageRating;
  final Map<String, int> reviewsByRating;
  final Map<String, int> feedbackByCategory;
  final Map<String, int> feedbackByStatus;
  final Map<String, int> feedbackByPriority;
  final List<Map<String, dynamic>> topRatedSites;
  final List<Map<String, dynamic>> recentFeedback;
  final Map<String, dynamic> trends;

  FeedbackAnalytics({
    required this.totalReviews,
    required this.totalAppFeedback,
    required this.averageRating,
    required this.reviewsByRating,
    required this.feedbackByCategory,
    required this.feedbackByStatus,
    required this.feedbackByPriority,
    required this.topRatedSites,
    required this.recentFeedback,
    required this.trends,
  });

  factory FeedbackAnalytics.fromJson(Map<String, dynamic> json) {
    return FeedbackAnalytics(
      totalReviews: json['totalReviews'] ?? 0,
      totalAppFeedback: json['totalAppFeedback'] ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewsByRating: Map<String, int>.from(json['reviewsByRating'] ?? {}),
      feedbackByCategory: Map<String, int>.from(json['feedbackByCategory'] ?? {}),
      feedbackByStatus: Map<String, int>.from(json['feedbackByStatus'] ?? {}),
      feedbackByPriority: Map<String, int>.from(json['feedbackByPriority'] ?? {}),
      topRatedSites: List<Map<String, dynamic>>.from(json['topRatedSites'] ?? []),
      recentFeedback: List<Map<String, dynamic>>.from(json['recentFeedback'] ?? []),
      trends: Map<String, dynamic>.from(json['trends'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReviews': totalReviews,
      'totalAppFeedback': totalAppFeedback,
      'averageRating': averageRating,
      'reviewsByRating': reviewsByRating,
      'feedbackByCategory': feedbackByCategory,
      'feedbackByStatus': feedbackByStatus,
      'feedbackByPriority': feedbackByPriority,
      'topRatedSites': topRatedSites,
      'recentFeedback': recentFeedback,
      'trends': trends,
    };
  }
}

// Review Report
class ReviewReport {
  final String id;
  final String reviewId;
  final String reporterId;
  final String reason;
  final String? description;
  final String status;
  final String? moderatorId;
  final String? moderatorNotes;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  ReviewReport({
    required this.id,
    required this.reviewId,
    required this.reporterId,
    required this.reason,
    this.description,
    required this.status,
    this.moderatorId,
    this.moderatorNotes,
    required this.createdAt,
    this.resolvedAt,
  });

  factory ReviewReport.fromJson(Map<String, dynamic> json) {
    return ReviewReport(
      id: json['id'],
      reviewId: json['reviewId'],
      reporterId: json['reporterId'],
      reason: json['reason'],
      description: json['description'],
      status: json['status'],
      moderatorId: json['moderatorId'],
      moderatorNotes: json['moderatorNotes'],
      createdAt: DateTime.parse(json['createdAt']),
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewId': reviewId,
      'reporterId': reporterId,
      'reason': reason,
      'description': description,
      'status': status,
      'moderatorId': moderatorId,
      'moderatorNotes': moderatorNotes,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }
}

// Feedback Category
class FeedbackCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isActive;
  final int sortOrder;

  FeedbackCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.isActive,
    required this.sortOrder,
  });

  factory FeedbackCategory.fromJson(Map<String, dynamic> json) {
    return FeedbackCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      isActive: json['isActive'] ?? true,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }
}
