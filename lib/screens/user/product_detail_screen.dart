import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            onPressed: () {
              // Add to wishlist functionality
            },
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Images
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      itemCount: widget.product.images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: widget.product.images[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
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
                  if (widget.product.images.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.product.images.asMap().entries.map((entry) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedImageIndex == entry.key
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  // Product Details
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          widget.product.description,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Size Selection
                        if (widget.product.sizes.isNotEmpty) ...[
                          const Text(
                            'Size',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.product.sizes.map((size) {
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
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Color Selection
                        if (widget.product.colors.isNotEmpty) ...[
                          const Text(
                            'Color',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            children: widget.product.colors.map((color) {
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
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey[300]!,
                                      width: isSelected ? 3 : 1,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Quantity Selection
                        Row(
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (_quantity < widget.product.stock) {
                                      setState(() {
                                        _quantity++;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add to Cart Button
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canAddToCart() ? _addToCart : null,
                child: Text(
                  'Add to Cart - \$${(widget.product.price * _quantity).toStringAsFixed(2)}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canAddToCart() {
    if (widget.product.sizes.isNotEmpty && _selectedSize == null) return false;
    if (widget.product.colors.isNotEmpty && _selectedColor == null) return false;
    return widget.product.stock > 0;
  }

  void _addToCart() {
    final cartItem = CartItem(
      id: const Uuid().v4(),
      productId: widget.product.id,
      productName: widget.product.name,
      productImage: widget.product.images.isNotEmpty 
          ? widget.product.images.first 
          : 'https://via.placeholder.com/200x200',
      price: widget.product.price,
      size: _selectedSize ?? '',
      color: _selectedColor ?? '',
      quantity: _quantity,
    );

    Provider.of<CartProvider>(context, listen: false).addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart!'),
        backgroundColor: Colors.green,
      ),
    );
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
      case 'yellow':
        return Colors.yellow;
      case 'brown':
        return Colors.brown;
      case 'grey':
      case 'gray':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}