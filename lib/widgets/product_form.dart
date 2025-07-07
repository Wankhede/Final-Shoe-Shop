import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/shoe.dart';

class ProductForm extends StatefulWidget {
  final VoidCallback onClose;
  final Function(Shoe) onSave;
  final Shoe? editingShoe;

  const ProductForm({
    super.key,
    required this.onClose,
    required this.onSave,
    this.editingShoe,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'men';
  List<String> _features = [''];
  List<String> _colors = [''];
  List<double> _selectedSizes = [];
  List<String> _images = [];
  bool _inStock = true;

  final List<String> _categories = ['men', 'women', 'kids', 'sports'];
  final List<double> _availableSizes = [5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12, 12.5, 13];

  @override
  void initState() {
    super.initState();
    if (widget.editingShoe != null) {
      _initializeWithExistingShoe();
    }
  }

  void _initializeWithExistingShoe() {
    final shoe = widget.editingShoe!;
    _nameController.text = shoe.name;
    _brandController.text = shoe.brand;
    _priceController.text = shoe.price.toString();
    _originalPriceController.text = shoe.originalPrice?.toString() ?? '';
    _descriptionController.text = shoe.description;
    _selectedCategory = shoe.category;
    _features = List.from(shoe.features);
    _colors = List.from(shoe.colors);
    _selectedSizes = List.from(shoe.sizes);
    _images = List.from(shoe.images);
    _inStock = shoe.inStock;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.editingShoe != null ? 'Edit Product' : 'Add New Product',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Basic Info
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Product Name *'),
                          validator: (value) => value?.isEmpty == true ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _brandController,
                          decoration: const InputDecoration(labelText: 'Brand *'),
                          validator: (value) => value?.isEmpty == true ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(labelText: 'Category *'),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _priceController,
                                decoration: const InputDecoration(labelText: 'Price *'),
                                keyboardType: TextInputType.number,
                                validator: (value) => value?.isEmpty == true ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _originalPriceController,
                                decoration: const InputDecoration(labelText: 'Original Price'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(labelText: 'Description *'),
                          maxLines: 3,
                          validator: (value) => value?.isEmpty == true ? 'Required' : null,
                        ),
                        const SizedBox(height: 24),

                        // Images
                        const Text(
                          'Product Images *',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _pickImages,
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Gallery'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: _takePhoto,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Camera'),
                            ),
                          ],
                        ),
                        if (_images.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _images.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          _images[index],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _images.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Features
                        const Text(
                          'Features',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        ..._features.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: entry.value,
                                    decoration: const InputDecoration(labelText: 'Feature'),
                                    onChanged: (value) {
                                      _features[entry.key] = value;
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _features.removeAt(entry.key);
                                    });
                                  },
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        }),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _features.add('');
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Feature'),
                        ),
                        const SizedBox(height: 16),

                        // Colors
                        const Text(
                          'Colors *',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        ..._colors.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: entry.value,
                                    decoration: const InputDecoration(labelText: 'Color'),
                                    onChanged: (value) {
                                      _colors[entry.key] = value;
                                    },
                                    validator: (value) => value?.isEmpty == true ? 'Required' : null,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _colors.removeAt(entry.key);
                                    });
                                  },
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        }),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _colors.add('');
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Color'),
                        ),
                        const SizedBox(height: 16),

                        // Sizes
                        const Text(
                          'Available Sizes *',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableSizes.map((size) {
                            final isSelected = _selectedSizes.contains(size);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedSizes.remove(size);
                                  } else {
                                    _selectedSizes.add(size);
                                  }
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF2563EB) : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    size.toString(),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // In Stock
                        CheckboxListTile(
                          title: const Text('In Stock'),
                          value: _inStock,
                          onChanged: (value) {
                            setState(() {
                              _inStock = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onClose,
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveProduct,
                        child: Text(widget.editingShoe != null ? 'Update' : 'Add Product'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    for (final image in images) {
      // In a real app, you would upload these to a server
      // For demo purposes, we'll use placeholder URLs
      setState(() {
        _images.add('https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg?auto=compress&cs=tinysrgb&w=800');
      });
    }
  }

  void _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      // In a real app, you would upload this to a server
      // For demo purposes, we'll use a placeholder URL
      setState(() {
        _images.add('https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg?auto=compress&cs=tinysrgb&w=800');
      });
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one image')),
        );
        return;
      }

      if (_selectedSizes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one size')),
        );
        return;
      }

      final filteredFeatures = _features.where((f) => f.trim().isNotEmpty).toList();
      final filteredColors = _colors.where((c) => c.trim().isNotEmpty).toList();

      final shoe = Shoe(
        id: widget.editingShoe?.id ?? const Uuid().v4(),
        name: _nameController.text,
        brand: _brandController.text,
        category: _selectedCategory,
        price: double.parse(_priceController.text),
        originalPrice: _originalPriceController.text.isNotEmpty 
            ? double.parse(_originalPriceController.text) 
            : null,
        images: _images,
        description: _descriptionController.text,
        features: filteredFeatures,
        sizes: _selectedSizes,
        colors: filteredColors,
        rating: widget.editingShoe?.rating ?? 4.0,
        reviews: widget.editingShoe?.reviews ?? 0,
        inStock: _inStock,
      );

      widget.onSave(shoe);
    }
  }
}