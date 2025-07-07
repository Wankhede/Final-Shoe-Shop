import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final String status;
  final DeliveryAddress deliveryAddress;
  final PaymentInfo paymentInfo;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    required this.paymentInfo,
    required this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      total: json['total'].toDouble(),
      status: json['status'],
      deliveryAddress: DeliveryAddress.fromJson(json['deliveryAddress']),
      paymentInfo: PaymentInfo.fromJson(json['paymentInfo']),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'status': status,
      'deliveryAddress': deliveryAddress.toJson(),
      'paymentInfo': paymentInfo.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

class DeliveryAddress {
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  DeliveryAddress({
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }
}

class PaymentInfo {
  final String method;
  final String? transactionId;
  final String status;

  PaymentInfo({
    required this.method,
    this.transactionId,
    required this.status,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      method: json['method'],
      transactionId: json['transactionId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'transactionId': transactionId,
      'status': status,
    };
  }
}