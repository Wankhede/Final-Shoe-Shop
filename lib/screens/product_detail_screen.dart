import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../providers/app_provider.dart';
import '../models/cart_item.dart';
import '../widgets/custom_app_bar.dart';
import 'login_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  double? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackButton: true),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final shoe = appProvider.selectedShoe;
          if (shoe == null) return const SizedBox();

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Images
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          itemCount: shoe.images.length,
                          onPageChanged: (index) {
                            setState(() {
                              _selectedImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: shoe.images[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.error),
                              ),
                            );
                          },
                        ),
                      ),

                      // Image Indicators
                      if (shoe.images.length > 1)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: shoe.images.asMap().entries.map((entry) {
                              return Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _selectedImageIndex == entry.key
                                      ? const Color(0xFF2563EB)
                                      : Colors.grey[300],
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      // Product Info
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  shoe.brand,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.favorite_border),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              shoe.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Rating
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: shoe.rating,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${shoe.rating} (${shoe.reviews} reviews)',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Price
                            Row(
                              children: [
                                Text(
                                  '\$${shoe.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2563EB),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                if (shoe.originalPrice != null) ...[
                                  const SizedBox(width: 12),
                                  Text(
                                    '\$${shoe.originalPrice!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Save \$${(shoe.originalPrice! - shoe.price).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Description
                            Text(
                              shoe.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                height: 1.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Colors
                            const Text(
                              'Color',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              children: shoe.colors.map((color) {
                                final isSelected = _selectedColor == color;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = color;
                                    });
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _getColorFromName(color),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF2563EB)
                                            : Colors.grey[300]!,
                                        width: isSelected ? 3 : 1,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),

                            // Sizes
                            const Text(
                              'Size',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: shoe.sizes.map((size) {
                                final isSelected = _selectedSize == size;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedSize = size;
                                    });
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF2563EB)
                                          : Colors.white,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF2563EB)
                                            : Colors.grey[300]!,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        size.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),

                            // Quantity
                            Row(
                              children: [
                                const Text(
                                  'Quantity',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (_quantity > 1) {
                                          setState(() {
                                            _quantity--;
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _quantity.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _quantity++;
                                        });
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Features
                            const Text(
                              'Features',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...shoe.features.map((feature) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _addToCart(appProvider, false),
                        child: const Text('Add to Cart'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _addToCart(appProvider, true),
                        child: const Text('Buy Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addToCart(AppProvider appProvider, bool buyNow) {
    if (appProvider.user == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }

    if (_selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a size')),
      );
      return;
    }

    final cartItem = CartItem(
      shoe: appProvider.selectedShoe!,
      size: _selectedSize!,
      color: _selectedColor ?? appProvider.selectedShoe!.colors.first,
      quantity: _quantity,
    );

    appProvider.addToCart(cartItem);

    if (buyNow) {
      // Navigate to checkout
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proceeding to checkout...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to cart!')),
      );
    }
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'navy':
        return const Color(0xFF1E3A8A);
      case 'nude':
        return const Color(0xFFD2B48C);
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'tan':
        return const Color(0xFFD2691E);
      case 'neon':
        return Colors.lime;
      default:
        return Colors.grey;
    }
  }
}