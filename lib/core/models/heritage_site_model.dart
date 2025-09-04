class HeritageSiteModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String period;
  final String location;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final List<String> imageGallery;
  final double rating;
  final int reviewCount;
  final bool hasAR;
  final List<ARModel> arModels;
  final List<String> tags;
  final String culturalSignificance;
  final String historicalContext;
  final List<String> nearbySites;
  final SiteAccessibility accessibility;
  final SiteTimings timings;
  final SitePricing pricing;
  final List<String> languages;
  final DateTime lastUpdated;

  HeritageSiteModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.period,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.imageGallery,
    required this.rating,
    required this.reviewCount,
    required this.hasAR,
    required this.arModels,
    required this.tags,
    required this.culturalSignificance,
    required this.historicalContext,
    required this.nearbySites,
    required this.accessibility,
    required this.timings,
    required this.pricing,
    required this.languages,
    required this.lastUpdated,
  });

  factory HeritageSiteModel.fromJson(Map<String, dynamic> json) {
    return HeritageSiteModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      period: json['period'] as String,
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      imageGallery: List<String>.from(json['imageGallery'] as List),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      hasAR: json['hasAR'] as bool,
      arModels: (json['arModels'] as List)
          .map((model) => ARModel.fromJson(model as Map<String, dynamic>))
          .toList(),
      tags: List<String>.from(json['tags'] as List),
      culturalSignificance: json['culturalSignificance'] as String,
      historicalContext: json['historicalContext'] as String,
      nearbySites: List<String>.from(json['nearbySites'] as List),
      accessibility: SiteAccessibility.fromJson(json['accessibility'] as Map<String, dynamic>),
      timings: SiteTimings.fromJson(json['timings'] as Map<String, dynamic>),
      pricing: SitePricing.fromJson(json['pricing'] as Map<String, dynamic>),
      languages: List<String>.from(json['languages'] as List),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'period': period,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'imageGallery': imageGallery,
      'rating': rating,
      'reviewCount': reviewCount,
      'hasAR': hasAR,
      'arModels': arModels.map((model) => model.toJson()).toList(),
      'tags': tags,
      'culturalSignificance': culturalSignificance,
      'historicalContext': historicalContext,
      'nearbySites': nearbySites,
      'accessibility': accessibility.toJson(),
      'timings': timings.toJson(),
      'pricing': pricing.toJson(),
      'languages': languages,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  double calculateDistance(double userLat, double userLng) {
    // Haversine formula for calculating distance between two points
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    double lat1Rad = userLat * (3.14159265359 / 180);
    double lat2Rad = latitude * (3.14159265359 / 180);
    double deltaLatRad = (latitude - userLat) * (3.14159265359 / 180);
    double deltaLngRad = (longitude - userLng) * (3.14159265359 / 180);

    double a = (deltaLatRad / 2).sin() * (deltaLatRad / 2).sin() +
        lat1Rad.cos() * lat2Rad.cos() *
        (deltaLngRad / 2).sin() * (deltaLngRad / 2).sin();
    double c = 2 * (a.sqrt()).asin();

    return earthRadius * c;
  }
}

class ARModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String modelUrl;
  final String thumbnailUrl;
  final String historicalContext;
  final String significance;
  final List<String> audioNarrations;
  final Map<String, String> subtitles;
  final ARModelMetadata metadata;

  ARModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.modelUrl,
    required this.thumbnailUrl,
    required this.historicalContext,
    required this.significance,
    required this.audioNarrations,
    required this.subtitles,
    required this.metadata,
  });

  factory ARModel.fromJson(Map<String, dynamic> json) {
    return ARModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      modelUrl: json['modelUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      historicalContext: json['historicalContext'] as String,
      significance: json['significance'] as String,
      audioNarrations: List<String>.from(json['audioNarrations'] as List),
      subtitles: Map<String, String>.from(json['subtitles'] as Map),
      metadata: ARModelMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'modelUrl': modelUrl,
      'thumbnailUrl': thumbnailUrl,
      'historicalContext': historicalContext,
      'significance': significance,
      'audioNarrations': audioNarrations,
      'subtitles': subtitles,
      'metadata': metadata.toJson(),
    };
  }
}

class ARModelMetadata {
  final double scale;
  final List<double> position;
  final List<double> rotation;
  final bool isInteractive;
  final List<String> interactionPoints;
  final String animationType;

  ARModelMetadata({
    required this.scale,
    required this.position,
    required this.rotation,
    required this.isInteractive,
    required this.interactionPoints,
    required this.animationType,
  });

  factory ARModelMetadata.fromJson(Map<String, dynamic> json) {
    return ARModelMetadata(
      scale: (json['scale'] as num).toDouble(),
      position: List<double>.from(json['position'] as List),
      rotation: List<double>.from(json['rotation'] as List),
      isInteractive: json['isInteractive'] as bool,
      interactionPoints: List<String>.from(json['interactionPoints'] as List),
      animationType: json['animationType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scale': scale,
      'position': position,
      'rotation': rotation,
      'isInteractive': isInteractive,
      'interactionPoints': interactionPoints,
      'animationType': animationType,
    };
  }
}

class SiteAccessibility {
  final bool wheelchairAccessible;
  final bool audioGuideAvailable;
  final bool signLanguageGuideAvailable;
  final bool brailleGuideAvailable;
  final List<String> accessibilityFeatures;

  SiteAccessibility({
    required this.wheelchairAccessible,
    required this.audioGuideAvailable,
    required this.signLanguageGuideAvailable,
    required this.brailleGuideAvailable,
    required this.accessibilityFeatures,
  });

  factory SiteAccessibility.fromJson(Map<String, dynamic> json) {
    return SiteAccessibility(
      wheelchairAccessible: json['wheelchairAccessible'] as bool,
      audioGuideAvailable: json['audioGuideAvailable'] as bool,
      signLanguageGuideAvailable: json['signLanguageGuideAvailable'] as bool,
      brailleGuideAvailable: json['brailleGuideAvailable'] as bool,
      accessibilityFeatures: List<String>.from(json['accessibilityFeatures'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wheelchairAccessible': wheelchairAccessible,
      'audioGuideAvailable': audioGuideAvailable,
      'signLanguageGuideAvailable': signLanguageGuideAvailable,
      'brailleGuideAvailable': brailleGuideAvailable,
      'accessibilityFeatures': accessibilityFeatures,
    };
  }
}

class SiteTimings {
  final String openingTime;
  final String closingTime;
  final List<String> closedDays;
  final String bestTimeToVisit;
  final String averageVisitDuration;

  SiteTimings({
    required this.openingTime,
    required this.closingTime,
    required this.closedDays,
    required this.bestTimeToVisit,
    required this.averageVisitDuration,
  });

  factory SiteTimings.fromJson(Map<String, dynamic> json) {
    return SiteTimings(
      openingTime: json['openingTime'] as String,
      closingTime: json['closingTime'] as String,
      closedDays: List<String>.from(json['closedDays'] as List),
      bestTimeToVisit: json['bestTimeToVisit'] as String,
      averageVisitDuration: json['averageVisitDuration'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openingTime': openingTime,
      'closingTime': closingTime,
      'closedDays': closedDays,
      'bestTimeToVisit': bestTimeToVisit,
      'averageVisitDuration': averageVisitDuration,
    };
  }
}

class SitePricing {
  final double adultPrice;
  final double childPrice;
  final double seniorPrice;
  final String currency;
  final List<String> includedServices;
  final List<String> optionalServices;

  SitePricing({
    required this.adultPrice,
    required this.childPrice,
    required this.seniorPrice,
    required this.currency,
    required this.includedServices,
    required this.optionalServices,
  });

  factory SitePricing.fromJson(Map<String, dynamic> json) {
    return SitePricing(
      adultPrice: (json['adultPrice'] as num).toDouble(),
      childPrice: (json['childPrice'] as num).toDouble(),
      seniorPrice: (json['seniorPrice'] as num).toDouble(),
      currency: json['currency'] as String,
      includedServices: List<String>.from(json['includedServices'] as List),
      optionalServices: List<String>.from(json['optionalServices'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adultPrice': adultPrice,
      'childPrice': childPrice,
      'seniorPrice': seniorPrice,
      'currency': currency,
      'includedServices': includedServices,
      'optionalServices': optionalServices,
    };
  }
}
