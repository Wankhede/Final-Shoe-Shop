import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/shoe.dart';
import '../models/category.dart';
import '../models/cart_item.dart';
import '../data/mock_data.dart';
import '../services/firebase_service.dart';

class AppProvider extends ChangeNotifier {
  User? _user;
  List<CartItem> _cart = [];
  List<String> _wishlist = [];
  String _currentView = 'home';
  String? _selectedCategory;
  Shoe? _selectedShoe;
  List<Shoe> _shoes = MockData.shoes;
  final List<Category> _categories = MockData.categories;
  bool _isLoading = false;

  // Getters
  User? get user => _user;
  List<CartItem> get cart => _cart;
  List<String> get wishlist => _wishlist;
  String get currentView => _currentView;
  String? get selectedCategory => _selectedCategory;
  Shoe? get selectedShoe => _selectedShoe;
  List<Shoe> get shoes => _shoes;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  int get cartItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal => _cart.fold(0, (sum, item) => sum + item.totalPrice);
  int get wishlistCount => _wishlist.length;

  // Authentication
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      // For demo purposes, keep the mock login
      if (email == 'admin@shoeshop.com' && password == 'admin') {
        _user = MockData.mockAdmin;
        _currentView = 'admin';
        notifyListeners();
        return true;
      } else if (email == 'user@example.com' && password == 'user') {
        _user = MockData.mockUser;
        _currentView = 'home';
        await _loadUserData();
        notifyListeners();
        return true;
      }
      
      // Try Firebase authentication
      final user = await FirebaseService.signInWithEmailPassword(email, password);
      if (user != null) {
        _user = user;
        _currentView = user.role == UserRole.admin ? 'admin' : 'home';
        await _loadUserData();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await FirebaseService.signOut();
    _user = null;
    _cart.clear();
    _wishlist.clear();
    _currentView = 'home';
    _selectedCategory = null;
    _selectedShoe = null;
    notifyListeners();
  }

  // Data Loading
  Future<void> _loadUserData() async {
    if (_user == null) return;
    
    try {
      // Load user's wishlist
      _wishlist = await FirebaseService.getUserWishlist(_user!.id);
      
      // Load shoes from Firebase
      _shoes = await FirebaseService.getShoes();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> loadShoes() async {
    _setLoading(true);
    try {
      _shoes = await FirebaseService.getShoes();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading shoes: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Navigation
  void setCurrentView(String view) {
    _currentView = view;
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedShoe(Shoe? shoe) {
    _selectedShoe = shoe;
    notifyListeners();
  }

  // Cart Management
  void addToCart(CartItem item) {
    final existingIndex = _cart.indexWhere(
      (cartItem) => cartItem.shoe.id == item.shoe.id && 
                   cartItem.size == item.size &&
                   cartItem.color == item.color,
    );

    if (existingIndex >= 0) {
      _cart[existingIndex] = _cart[existingIndex].copyWith(
        quantity: _cart[existingIndex].quantity + item.quantity,
      );
    } else {
      _cart.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(String shoeId, double size) {
    _cart.removeWhere((item) => item.shoe.id == shoeId && item.size == size);
    notifyListeners();
  }

  void updateCartItemQuantity(String shoeId, double size, int quantity) {
    final index = _cart.indexWhere(
      (item) => item.shoe.id == shoeId && item.size == size,
    );
    if (index >= 0) {
      if (quantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index] = _cart[index].copyWith(quantity: quantity);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Wishlist Management
  Future<void> toggleWishlist(String shoeId) async {
    if (_user == null) return;

    try {
      if (_wishlist.contains(shoeId)) {
        await FirebaseService.removeFromWishlist(_user!.id, shoeId);
        _wishlist.remove(shoeId);
      } else {
        await FirebaseService.addToWishlist(_user!.id, shoeId);
        _wishlist.add(shoeId);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling wishlist: $e');
    }
  }

  bool isInWishlist(String shoeId) {
    return _wishlist.contains(shoeId);
  }

  // Product Management (Admin only)
  Future<void> addShoe(Shoe shoe) async {
    if (_user?.role != UserRole.admin) return;
    
    _setLoading(true);
    try {
      final shoeId = await FirebaseService.addShoe(shoe);
      final newShoe = shoe.copyWith(id: shoeId);
      _shoes.add(newShoe);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding shoe: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateShoe(Shoe updatedShoe) async {
    if (_user?.role != UserRole.admin) return;
    
    _setLoading(true);
    try {
      await FirebaseService.updateShoe(updatedShoe);
      final index = _shoes.indexWhere((shoe) => shoe.id == updatedShoe.id);
      if (index >= 0) {
        _shoes[index] = updatedShoe;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating shoe: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteShoe(String shoeId) async {
    if (_user?.role != UserRole.admin) return;
    
    _setLoading(true);
    try {
      await FirebaseService.deleteShoe(shoeId);
      _shoes.removeWhere((shoe) => shoe.id == shoeId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting shoe: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search and Filter
  List<Shoe> getShoesByCategory(String category) {
    return _shoes.where((shoe) => shoe.category == category).toList();
  }

  List<Shoe> searchShoes(String query) {
    return _shoes.where((shoe) =>
      shoe.name.toLowerCase().contains(query.toLowerCase()) ||
      shoe.brand.toLowerCase().contains(query.toLowerCase()) ||
      shoe.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Utility
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}