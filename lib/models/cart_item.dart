import 'shoe.dart';

class CartItem {
  final Shoe shoe;
  final double size;
  final String color;
  final int quantity;

  CartItem({
    required this.shoe,
    required this.size,
    required this.color,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      shoe: Shoe.fromJson(json['shoe']),
      size: json['size'].toDouble(),
      color: json['color'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shoe': shoe.toJson(),
      'size': size,
      'color': color,
      'quantity': quantity,
    };
  }

  CartItem copyWith({
    Shoe? shoe,
    double? size,
    String? color,
    int? quantity,
  }) {
    return CartItem(
      shoe: shoe ?? this.shoe,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => shoe.price * quantity;
}