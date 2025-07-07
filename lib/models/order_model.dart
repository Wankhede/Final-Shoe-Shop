import 'cart_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String status; // 'pending', 'shipped', 'delivered', 'cancelled'
  final DeliveryAddress deliveryAddress;
  final DateTime orderDate;
  final DateTime? shippedDate;
  final DateTime? deliveredDate;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    required this.orderDate,
    this.shippedDate,
    this.deliveredDate,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items:
          (map['items'] as List).map((item) => CartItem.fromMap(item)).toList(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      deliveryAddress: DeliveryAddress.fromMap(map['deliveryAddress']),
      orderDate: DateTime.parse(map['orderDate']),
      shippedDate: map['shippedDate'] != null
          ? DateTime.parse(map['shippedDate'])
          : null,
      deliveredDate: map['deliveredDate'] != null
          ? DateTime.parse(map['deliveredDate'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'deliveryAddress': deliveryAddress.toMap(),
      'orderDate': orderDate.toIso8601String(),
      'shippedDate': shippedDate?.toIso8601String(),
      'deliveredDate': deliveredDate?.toIso8601String(),
    };
  }

  bool get isDelayed {
    final now = DateTime.now();
    final hoursSinceOrder = now.difference(orderDate).inHours;
    return status == 'pending' && hoursSinceOrder > 48;
  }
}

class DeliveryAddress {
  final String name;
  final String address;
  final String pincode;
  final String phone;

  DeliveryAddress({
    required this.name,
    required this.address,
    required this.pincode,
    required this.phone,
  });

  factory DeliveryAddress.fromMap(Map<String, dynamic> map) {
    return DeliveryAddress(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      pincode: map['pincode'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'pincode': pincode,
      'phone': phone,
    };
  }
}
