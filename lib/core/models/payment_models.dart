import 'dart:convert';

// Payment Methods
enum PaymentMethod {
  creditCard,
  debitCard,
  upi,
  netBanking,
  wallet,
  cashOnDelivery,
}

// Ticket Types
enum TicketType {
  adult,
  child,
  senior,
  student,
  group,
  vip,
}

// Payment Status
enum PaymentStatusEnum {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
}

// Payment Intent
class PaymentIntent {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final PaymentStatusEnum status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final Map<String, dynamic> metadata;
  final String? description;

  PaymentIntent({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    required this.metadata,
    this.description,
  });

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    return PaymentIntent(
      id: json['id'],
      userId: json['userId'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      status: PaymentStatusEnum.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PaymentStatusEnum.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'metadata': metadata,
      'description': description,
    };
  }
}

// Payment Result
class PaymentResult {
  final String id;
  final bool success;
  final String? transactionId;
  final String? errorMessage;
  final DateTime processedAt;
  final Map<String, dynamic> details;

  PaymentResult({
    required this.id,
    required this.success,
    this.transactionId,
    this.errorMessage,
    required this.processedAt,
    required this.details,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      id: json['id'],
      success: json['success'],
      transactionId: json['transactionId'],
      errorMessage: json['errorMessage'],
      processedAt: DateTime.parse(json['processedAt']),
      details: Map<String, dynamic>.from(json['details'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'success': success,
      'transactionId': transactionId,
      'errorMessage': errorMessage,
      'processedAt': processedAt.toIso8601String(),
      'details': details,
    };
  }
}

// Payment Status
class PaymentStatus {
  final String id;
  final PaymentStatusEnum status;
  final DateTime lastUpdated;
  final String? failureReason;
  final Map<String, dynamic> metadata;

  PaymentStatus({
    required this.id,
    required this.status,
    required this.lastUpdated,
    this.failureReason,
    required this.metadata,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(
      id: json['id'],
      status: PaymentStatusEnum.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PaymentStatusEnum.pending,
      ),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      failureReason: json['failureReason'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.name,
      'lastUpdated': lastUpdated.toIso8601String(),
      'failureReason': failureReason,
      'metadata': metadata,
    };
  }
}

// Refund Result
class RefundResult {
  final String id;
  final String paymentIntentId;
  final double amount;
  final String reason;
  final bool success;
  final DateTime processedAt;
  final String? refundId;

  RefundResult({
    required this.id,
    required this.paymentIntentId,
    required this.amount,
    required this.reason,
    required this.success,
    required this.processedAt,
    this.refundId,
  });

  factory RefundResult.fromJson(Map<String, dynamic> json) {
    return RefundResult(
      id: json['id'],
      paymentIntentId: json['paymentIntentId'],
      amount: (json['amount'] as num).toDouble(),
      reason: json['reason'],
      success: json['success'],
      processedAt: DateTime.parse(json['processedAt']),
      refundId: json['refundId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentIntentId': paymentIntentId,
      'amount': amount,
      'reason': reason,
      'success': success,
      'processedAt': processedAt.toIso8601String(),
      'refundId': refundId,
    };
  }
}

// Payment Transaction
class PaymentTransaction {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final PaymentStatusEnum status;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final String? description;
  final Map<String, dynamic> metadata;

  PaymentTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.description,
    required this.metadata,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'],
      userId: json['userId'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      status: PaymentStatusEnum.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PaymentStatusEnum.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod'],
        orElse: () => PaymentMethod.creditCard,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      description: json['description'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'metadata': metadata,
    };
  }
}

// Merchandise Item
class MerchandiseItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int quantity;
  final String? imageUrl;
  final Map<String, dynamic> attributes;

  MerchandiseItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.quantity,
    this.imageUrl,
    required this.attributes,
  });

  factory MerchandiseItem.fromJson(Map<String, dynamic> json) {
    return MerchandiseItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      currency: json['currency'],
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
      attributes: Map<String, dynamic>.from(json['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'attributes': attributes,
    };
  }
}

// Shipping Address
class ShippingAddress {
  final String name;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? phone;

  ShippingAddress({
    required this.name,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.phone,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      name: json['name'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'phone': phone,
    };
  }
}

// Coupon Validation
class CouponValidation {
  final String code;
  final bool isValid;
  final double discountAmount;
  final String discountType; // 'percentage' or 'fixed'
  final DateTime? expiryDate;
  final List<String> applicableItems;
  final String? description;

  CouponValidation({
    required this.code,
    required this.isValid,
    required this.discountAmount,
    required this.discountType,
    this.expiryDate,
    required this.applicableItems,
    this.description,
  });

  factory CouponValidation.fromJson(Map<String, dynamic> json) {
    return CouponValidation(
      code: json['code'],
      isValid: json['isValid'],
      discountAmount: (json['discountAmount'] as num).toDouble(),
      discountType: json['discountType'],
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      applicableItems: List<String>.from(json['applicableItems'] ?? []),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'isValid': isValid,
      'discountAmount': discountAmount,
      'discountType': discountType,
      'expiryDate': expiryDate?.toIso8601String(),
      'applicableItems': applicableItems,
      'description': description,
    };
  }
}
