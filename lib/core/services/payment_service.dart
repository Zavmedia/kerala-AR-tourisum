import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/payment_models.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  late final Dio _dio;
  static const String _baseUrl = 'https://api.zenscape-tourism.com/v1/payments';

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    _isInitialized = true;
  }

  // Ticket Booking
  Future<PaymentIntent> createTicketBooking({
    required String heritageSiteId,
    required String userId,
    required DateTime visitDate,
    required int numberOfTickets,
    required TicketType ticketType,
    String? specialRequirements,
  }) async {
    try {
      final response = await _dio.post('/tickets/book', data: {
        'heritageSiteId': heritageSiteId,
        'userId': userId,
        'visitDate': visitDate.toIso8601String(),
        'numberOfTickets': numberOfTickets,
        'ticketType': ticketType.name,
        'specialRequirements': specialRequirements,
      });

      return PaymentIntent.fromJson(response.data);
    } on DioException catch (e) {
      throw PaymentException('Failed to create ticket booking: ${e.message}');
    }
  }

  // Merchandise Purchase
  Future<PaymentIntent> createMerchandiseOrder({
    required List<MerchandiseItem> items,
    required String userId,
    required ShippingAddress shippingAddress,
    String? couponCode,
  }) async {
    try {
      final response = await _dio.post('/merchandise/order', data: {
        'items': items.map((item) => item.toJson()).toList(),
        'userId': userId,
        'shippingAddress': shippingAddress.toJson(),
        'couponCode': couponCode,
      });

      return PaymentIntent.fromJson(response.data);
    } on DioException catch (e) {
      throw PaymentException('Failed to create merchandise order: ${e.message}');
    }
  }

  // Payment Processing
  Future<PaymentResult> processPayment({
    required String paymentIntentId,
    required PaymentMethod paymentMethod,
    required Map<String, dynamic> paymentDetails,
  }) async {
    try {
      final response = await _dio.post('/process', data: {
        'paymentIntentId': paymentIntentId,
        'paymentMethod': paymentMethod.name,
        'paymentDetails': paymentDetails,
      });

      return PaymentResult.fromJson(response.data);
    } on DioException catch (e) {
      throw PaymentException('Payment processing failed: ${e.message}');
    }
  }

  // Payment Status
  Future<PaymentStatus> getPaymentStatus(String paymentIntentId) async {
    try {
      final response = await _dio.get('/status/$paymentIntentId');
      return PaymentStatus.fromJson(response.data);
    } on DioException catch (e) {
      throw PaymentException('Failed to get payment status: ${e.message}');
    }
  }

  // Refund Processing
  Future<RefundResult> processRefund({
    required String paymentIntentId,
    required double amount,
    required String reason,
  }) async {
    try {
      final response = await _dio.post('/refund', data: {
        'paymentIntentId': paymentIntentId,
        'amount': amount,
        'reason': reason,
      });

      return RefundResult.fromJson(response.data);
    } on DioException catch (e) {
      throw PaymentException('Refund processing failed: ${e.message}');
    }
  }

  // Payment History
  Future<List<PaymentTransaction>> getPaymentHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get('/history', queryParameters: {
        'userId': userId,
        'page': page,
        'limit': limit,
      });

      final List<dynamic> transactionsData = response.data['transactions'];
      return transactionsData.map((t) => PaymentTransaction.fromJson(t)).toList();
    } on DioException catch (e) {
      throw PaymentException('Failed to get payment history: ${e.message}');
    }
  }

  // Available Payment Methods
  Future<List<PaymentMethod>> getAvailablePaymentMethods() async {
    try {
      final response = await _dio.get('/methods');
      final List<dynamic> methodsData = response.data['methods'];
      return methodsData.map((m) => PaymentMethod.values.firstWhere(
        (method) => method.name == m['name'],
        orElse: () => PaymentMethod.creditCard,
      )).toList();
    } on DioException catch (e) {
      throw PaymentException('Failed to get payment methods: ${e.message}');
    }
  }

  // Validate Coupon
  Future<CouponValidation> validateCoupon(String couponCode) async {
    try {
      final response = await _dio.post('/coupons/validate', data: {
        'couponCode': couponCode,
      });

      return CouponValidation.fromJson(response.data);
    } on DioException catch (e) {
      throw PaymentException('Failed to validate coupon: ${e.message}');
    }
  }
}

class PaymentException implements Exception {
  final String message;
  PaymentException(this.message);
  
  @override
  String toString() => 'PaymentException: $message';
}
