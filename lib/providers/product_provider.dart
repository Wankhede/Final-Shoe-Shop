import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'all';
  String _searchQuery = '';

  List<ProductModel> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  List<String> get categories => ['all', 'men', 'women', 'boys', 'girls'];

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore.collection('products').get();
      _products =
          snapshot.docs.map((doc) => ProductModel.fromMap(doc.data())).toList();
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'all' || product.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<bool> addProduct(ProductModel product, List<String> imagePaths) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Upload images
      List<String> imageUrls = [];
      for (String imagePath in imagePaths) {
        final ref = _storage.ref().child('products/${const Uuid().v4()}');
        // Note: In a real app, you'd upload the actual file
        // For demo purposes, we'll use placeholder URLs
        imageUrls.add('https://via.placeholder.com/400x400');
      }

      final productWithImages = product.copyWith(images: imageUrls);
      await _firestore
          .collection('products')
          .doc(product.id)
          .set(productWithImages.toMap());

      _products.add(productWithImages);
      _applyFilters();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProduct(ProductModel product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        _applyFilters();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      _products.removeWhere((p) => p.id == productId);
      _applyFilters();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ProductModel> getLowStockProducts() {
    return _products.where((product) => product.stock < 10).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
