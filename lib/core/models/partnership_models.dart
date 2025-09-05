import 'dart:convert';

// Partnership Status
enum PartnershipStatus {
  pending,
  active,
  suspended,
  terminated,
  expired,
}

// Partnership Types
enum PartnershipType {
  localBusiness,
  tourGuide,
  accommodation,
  transportation,
  restaurant,
  souvenir,
  cultural,
}

// Local Business
class LocalBusiness {
  final String id;
  final String name;
  final String description;
  final String category;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String? email;
  final String? website;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final List<String> heritageSiteIds;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  LocalBusiness({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.email,
    this.website,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.heritageSiteIds,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocalBusiness.fromJson(Map<String, dynamic> json) {
    return LocalBusiness(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      address: json['address'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      images: List<String>.from(json['images'] ?? []),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      heritageSiteIds: List<String>.from(json['heritageSiteIds'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'website': website,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'isVerified': isVerified,
      'heritageSiteIds': heritageSiteIds,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// Tour Guide
class TourGuide {
  final String id;
  final String name;
  final String bio;
  final List<String> languages;
  final List<String> heritageSiteIds;
  final double rating;
  final int tourCount;
  final int experienceYears;
  final String? profileImage;
  final List<String> certifications;
  final double hourlyRate;
  final String currency;
  final bool isAvailable;
  final List<String> specializations;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  TourGuide({
    required this.id,
    required this.name,
    required this.bio,
    required this.languages,
    required this.heritageSiteIds,
    required this.rating,
    required this.tourCount,
    required this.experienceYears,
    this.profileImage,
    required this.certifications,
    required this.hourlyRate,
    required this.currency,
    required this.isAvailable,
    required this.specializations,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TourGuide.fromJson(Map<String, dynamic> json) {
    return TourGuide(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      languages: List<String>.from(json['languages'] ?? []),
      heritageSiteIds: List<String>.from(json['heritageSiteIds'] ?? []),
      rating: (json['rating'] as num).toDouble(),
      tourCount: json['tourCount'] ?? 0,
      experienceYears: json['experienceYears'] ?? 0,
      profileImage: json['profileImage'],
      certifications: List<String>.from(json['certifications'] ?? []),
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      currency: json['currency'],
      isAvailable: json['isAvailable'] ?? true,
      specializations: List<String>.from(json['specializations'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'languages': languages,
      'heritageSiteIds': heritageSiteIds,
      'rating': rating,
      'tourCount': tourCount,
      'experienceYears': experienceYears,
      'profileImage': profileImage,
      'certifications': certifications,
      'hourlyRate': hourlyRate,
      'currency': currency,
      'isAvailable': isAvailable,
      'specializations': specializations,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// Booking Result
class BookingResult {
  final String id;
  final String guideId;
  final String userId;
  final DateTime tourDate;
  final int duration;
  final String heritageSiteId;
  final double totalAmount;
  final String currency;
  final String status;
  final String? specialRequirements;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingResult({
    required this.id,
    required this.guideId,
    required this.userId,
    required this.tourDate,
    required this.duration,
    required this.heritageSiteId,
    required this.totalAmount,
    required this.currency,
    required this.status,
    this.specialRequirements,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingResult.fromJson(Map<String, dynamic> json) {
    return BookingResult(
      id: json['id'],
      guideId: json['guideId'],
      userId: json['userId'],
      tourDate: DateTime.parse(json['tourDate']),
      duration: json['duration'],
      heritageSiteId: json['heritageSiteId'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currency: json['currency'],
      status: json['status'],
      specialRequirements: json['specialRequirements'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guideId': guideId,
      'userId': userId,
      'tourDate': tourDate.toIso8601String(),
      'duration': duration,
      'heritageSiteId': heritageSiteId,
      'totalAmount': totalAmount,
      'currency': currency,
      'status': status,
      'specialRequirements': specialRequirements,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// Revenue Share
class RevenueShare {
  final String id;
  final String partnershipId;
  final String partnerId;
  final double platformShare;
  final double partnerShare;
  final String currency;
  final DateTime lastCalculated;
  final Map<String, dynamic> metadata;

  RevenueShare({
    required this.id,
    required this.partnershipId,
    required this.partnerId,
    required this.platformShare,
    required this.partnerShare,
    required this.currency,
    required this.lastCalculated,
    required this.metadata,
  });

  factory RevenueShare.fromJson(Map<String, dynamic> json) {
    return RevenueShare(
      id: json['id'],
      partnershipId: json['partnershipId'],
      partnerId: json['partnerId'],
      platformShare: (json['platformShare'] as num).toDouble(),
      partnerShare: (json['partnerShare'] as num).toDouble(),
      currency: json['currency'],
      lastCalculated: DateTime.parse(json['lastCalculated']),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partnershipId': partnershipId,
      'partnerId': partnerId,
      'platformShare': platformShare,
      'partnerShare': partnerShare,
      'currency': currency,
      'lastCalculated': lastCalculated.toIso8601String(),
      'metadata': metadata,
    };
  }
}

// Revenue Transaction
class RevenueTransaction {
  final String id;
  final String partnershipId;
  final String partnerId;
  final double amount;
  final String currency;
  final String type;
  final String description;
  final DateTime transactionDate;
  final Map<String, dynamic> metadata;

  RevenueTransaction({
    required this.id,
    required this.partnershipId,
    required this.partnerId,
    required this.amount,
    required this.currency,
    required this.type,
    required this.description,
    required this.transactionDate,
    required this.metadata,
  });

  factory RevenueTransaction.fromJson(Map<String, dynamic> json) {
    return RevenueTransaction(
      id: json['id'],
      partnershipId: json['partnershipId'],
      partnerId: json['partnerId'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      type: json['type'],
      description: json['description'],
      transactionDate: DateTime.parse(json['transactionDate']),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partnershipId': partnershipId,
      'partnerId': partnerId,
      'amount': amount,
      'currency': currency,
      'type': type,
      'description': description,
      'transactionDate': transactionDate.toIso8601String(),
      'metadata': metadata,
    };
  }
}

// Partnership
class Partnership {
  final String id;
  final String partnerId;
  final String partnerName;
  final PartnershipType type;
  final PartnershipStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final double revenueShare;
  final List<String> heritageSiteIds;
  final Map<String, dynamic> terms;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  Partnership({
    required this.id,
    required this.partnerId,
    required this.partnerName,
    required this.type,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.revenueShare,
    required this.heritageSiteIds,
    required this.terms,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Partnership.fromJson(Map<String, dynamic> json) {
    return Partnership(
      id: json['id'],
      partnerId: json['partnerId'],
      partnerName: json['partnerName'],
      type: PartnershipType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PartnershipType.localBusiness,
      ),
      status: PartnershipStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PartnershipStatus.pending,
      ),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      revenueShare: (json['revenueShare'] as num).toDouble(),
      heritageSiteIds: List<String>.from(json['heritageSiteIds'] ?? []),
      terms: Map<String, dynamic>.from(json['terms'] ?? {}),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partnerId': partnerId,
      'partnerName': partnerName,
      'type': type.name,
      'status': status.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'revenueShare': revenueShare,
      'heritageSiteIds': heritageSiteIds,
      'terms': terms,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// Partnership Request
class PartnershipRequest {
  final String partnerName;
  final PartnershipType type;
  final String description;
  final List<String> heritageSiteIds;
  final double proposedRevenueShare;
  final Map<String, dynamic> terms;
  final Map<String, dynamic> metadata;

  PartnershipRequest({
    required this.partnerName,
    required this.type,
    required this.description,
    required this.heritageSiteIds,
    required this.proposedRevenueShare,
    required this.terms,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'partnerName': partnerName,
      'type': type.name,
      'description': description,
      'heritageSiteIds': heritageSiteIds,
      'proposedRevenueShare': proposedRevenueShare,
      'terms': terms,
      'metadata': metadata,
    };
  }
}

// Partnership Analytics
class PartnershipAnalytics {
  final int totalPartnerships;
  final int activePartnerships;
  final double totalRevenue;
  final String currency;
  final Map<String, int> partnershipsByType;
  final Map<String, double> revenueByPartner;
  final List<Map<String, dynamic>> topPerformers;
  final Map<String, dynamic> growthMetrics;

  PartnershipAnalytics({
    required this.totalPartnerships,
    required this.activePartnerships,
    required this.totalRevenue,
    required this.currency,
    required this.partnershipsByType,
    required this.revenueByPartner,
    required this.topPerformers,
    required this.growthMetrics,
  });

  factory PartnershipAnalytics.fromJson(Map<String, dynamic> json) {
    return PartnershipAnalytics(
      totalPartnerships: json['totalPartnerships'] ?? 0,
      activePartnerships: json['activePartnerships'] ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'INR',
      partnershipsByType: Map<String, int>.from(json['partnershipsByType'] ?? {}),
      revenueByPartner: Map<String, double>.from(json['revenueByPartner'] ?? {}),
      topPerformers: List<Map<String, dynamic>>.from(json['topPerformers'] ?? []),
      growthMetrics: Map<String, dynamic>.from(json['growthMetrics'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPartnerships': totalPartnerships,
      'activePartnerships': activePartnerships,
      'totalRevenue': totalRevenue,
      'currency': currency,
      'partnershipsByType': partnershipsByType,
      'revenueByPartner': revenueByPartner,
      'topPerformers': topPerformers,
      'growthMetrics': growthMetrics,
    };
  }
}
