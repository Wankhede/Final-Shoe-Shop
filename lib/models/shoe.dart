class Shoe {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final double? originalPrice;
  final List<String> images;
  final String description;
  final List<String> features;
  final List<double> sizes;
  final List<String> colors;
  final double rating;
  final int reviews;
  final bool inStock;

  Shoe({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.images,
    required this.description,
    required this.features,
    required this.sizes,
    required this.colors,
    required this.rating,
    required this.reviews,
    required this.inStock,
  });

  factory Shoe.fromJson(Map<String, dynamic> json) {
    return Shoe(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      category: json['category'],
      price: json['price'].toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      images: List<String>.from(json['images']),
      description: json['description'],
      features: List<String>.from(json['features']),
      sizes: List<double>.from(json['sizes']),
      colors: List<String>.from(json['colors']),
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      inStock: json['inStock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'images': images,
      'description': description,
      'features': features,
      'sizes': sizes,
      'colors': colors,
      'rating': rating,
      'reviews': reviews,
      'inStock': inStock,
    };
  }

  Shoe copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    double? price,
    double? originalPrice,
    List<String>? images,
    String? description,
    List<String>? features,
    List<double>? sizes,
    List<String>? colors,
    double? rating,
    int? reviews,
    bool? inStock,
  }) {
    return Shoe(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      images: images ?? this.images,
      description: description ?? this.description,
      features: features ?? this.features,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      inStock: inStock ?? this.inStock,
    );
  }
}