import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<OrderModel> get delayedOrders => _orders.where((order) => order.isDelayed).toList();
  int get totalOrders => _orders.length;
  int get pendingOrders => _orders.where((order) => order.status == 'pending').length;

  Future<void> loadOrders({String? userId}) async {
    try {
      _isLoading = true;
      notifyListeners();

      Query query = _firestore.collection('orders');
      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final snapshot = await query.orderBy('orderDate', descending: true).get();
      _orders = snapshot.docs.map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrder(List<CartItem> items, DeliveryAddress address, String userId) async {
    try {
      final orderId = const Uuid().v4();
      final totalAmount = items.fold(0.0, (sum, item) => sum + item.totalPrice);
      
      final order = OrderModel(
        id: orderId,
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        status: 'pending',
        deliveryAddress: address,
        orderDate: DateTime.now(),
      );

      await _firestore.collection('orders').doc(orderId).set(order.toMap());
      _orders.insert(0, order);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      final updateData = <String, dynamic>{'status': status};
      
      if (status == 'shipped') {
        updateData['shippedDate'] = DateTime.now().toIso8601String();
      } else if (status == 'delivered') {
        updateData['deliveredDate'] = DateTime.now().toIso8601String();
      }

      await _firestore.collection('orders').doc(orderId).update(updateData);
      
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        final updatedOrder = OrderModel.fromMap({
          ..._orders[index].toMap(),
          ...updateData,
        });
        _orders[index] = updatedOrder;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}