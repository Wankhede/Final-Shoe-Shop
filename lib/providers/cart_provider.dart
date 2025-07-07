import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere(
      (cartItem) => cartItem.productId == item.productId && 
                   cartItem.size == item.size && 
                   cartItem.color == item.color,
    );

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}