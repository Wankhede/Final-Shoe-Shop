import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../providers/app_provider.dart';
import '../widgets/custom_app_bar.dart';
import 'product_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackButton: true),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final category = appProvider.categories.firstWhere(
            (cat) => cat.id == appProvider.selectedCategory,
          );
          final shoes = appProvider.getShoesByCategory(category.id);

          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${shoes.length} items available',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),

              // Products Grid
              Expanded(
                child: shoes.isEmpty
                    ? const Center(
                        child: Text(
                          'No shoes found in this category',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'Inter',
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: shoes.length,
                        itemBuilder: (context, index) {
                          final shoe = shoes[index];
                          return GestureDetector(
                            onTap: () {
                              appProvider.setSelectedShoe(shoe);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductDetailScreen(),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  Expanded(
                                    flex: 3,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: shoe.images.first,
                                            width: double.infinity,
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
                                          ),
                                        ),
                                        if (shoe.originalPrice != null)
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'SALE',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.8),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.favorite_border,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Details
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            shoe.brand,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            shoe.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Inter',
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              RatingBarIndicator(
                                                rating: shoe.rating,
                                                itemBuilder: (context, index) => const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 12.0,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '(${shoe.reviews})',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Text(
                                                '\$${shoe.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2563EB),
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                              if (shoe.originalPrice != null) ...[
                                                const SizedBox(width: 8),
                                                Text(
                                                  '\$${shoe.originalPrice!.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration.lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}