import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/shoe.dart';
import '../models/order.dart' as app_order;
import '../models/user.dart' as app_user;

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  static const String _shoesCollection = 'shoes';
  static const String _usersCollection = 'users';
  static const String _ordersCollection = 'orders';
  static const String _wishlistCollection = 'wishlist';

  // Authentication
  static Future<app_user.User?> signInWithEmailPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final userDoc = await _firestore
            .collection(_usersCollection)
            .doc(credential.user!.uid)
            .get();

        if (userDoc.exists) {
          return app_user.User.fromJson({
            'id': userDoc.id,
            ...userDoc.data()!,
          });
        }
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Shoes Management
  static Future<List<Shoe>> getShoes() async {
    try {
      final querySnapshot = await _firestore
          .collection(_shoesCollection)
          .where('inStock', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Shoe.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch shoes: ${e.toString()}');
    }
  }

  static Future<List<Shoe>> getShoesByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_shoesCollection)
          .where('category', isEqualTo: category)
          .where('inStock', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Shoe.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch shoes by category: ${e.toString()}');
    }
  }

  static Future<List<Shoe>> searchShoes(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_shoesCollection)
          .where('inStock', isEqualTo: true)
          .get();

      final shoes = querySnapshot.docs
          .map((doc) => Shoe.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      return shoes
          .where((shoe) =>
              shoe.name.toLowerCase().contains(query.toLowerCase()) ||
              shoe.brand.toLowerCase().contains(query.toLowerCase()) ||
              shoe.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search shoes: ${e.toString()}');
    }
  }

  static Future<String> addShoe(Shoe shoe) async {
    try {
      final docRef =
          await _firestore.collection(_shoesCollection).add(shoe.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add shoe: ${e.toString()}');
    }
  }

  static Future<void> updateShoe(Shoe shoe) async {
    try {
      await _firestore
          .collection(_shoesCollection)
          .doc(shoe.id)
          .update(shoe.toJson());
    } catch (e) {
      throw Exception('Failed to update shoe: ${e.toString()}');
    }
  }

  static Future<void> deleteShoe(String shoeId) async {
    try {
      await _firestore.collection(_shoesCollection).doc(shoeId).delete();
    } catch (e) {
      throw Exception('Failed to delete shoe: ${e.toString()}');
    }
  }

  // Image Upload
  static Future<String> uploadImage(File imageFile, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  // Orders Management
  static Future<String> createOrder(app_order.Order order) async {
    try {
      final docRef =
          await _firestore.collection(_ordersCollection).add(order.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create order: ${e.toString()}');
    }
  }

  static Future<List<app_order.Order>> getUserOrders(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => app_order.Order.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user orders: ${e.toString()}');
    }
  }

  static Future<List<app_order.Order>> getAllOrders() async {
    try {
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => app_order.Order.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all orders: ${e.toString()}');
    }
  }

  static Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection(_ordersCollection).doc(orderId).update(
          {'status': status, 'updatedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      throw Exception('Failed to update order status: ${e.toString()}');
    }
  }

  // Wishlist Management
  static Future<void> addToWishlist(String userId, String shoeId) async {
    try {
      await _firestore
          .collection(_wishlistCollection)
          .doc('${userId}_$shoeId')
          .set({
        'userId': userId,
        'shoeId': shoeId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add to wishlist: ${e.toString()}');
    }
  }

  static Future<void> removeFromWishlist(String userId, String shoeId) async {
    try {
      await _firestore
          .collection(_wishlistCollection)
          .doc('${userId}_$shoeId')
          .delete();
    } catch (e) {
      throw Exception('Failed to remove from wishlist: ${e.toString()}');
    }
  }

  static Future<List<String>> getUserWishlist(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_wishlistCollection)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data()['shoeId'] as String)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch wishlist: ${e.toString()}');
    }
  }

  // Analytics
  static Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final shoesSnapshot = await _firestore.collection(_shoesCollection).get();
      final ordersSnapshot =
          await _firestore.collection(_ordersCollection).get();
      final usersSnapshot = await _firestore.collection(_usersCollection).get();

      final totalRevenue = ordersSnapshot.docs
          .where((doc) => doc.data()['status'] == 'delivered')
          .fold(0.0, (sum, doc) => sum + (doc.data()['total'] ?? 0.0));

      return {
        'totalProducts': shoesSnapshot.size,
        'totalOrders': ordersSnapshot.size,
        'totalUsers': usersSnapshot.size,
        'totalRevenue': totalRevenue,
      };
    } catch (e) {
      throw Exception('Failed to fetch dashboard stats: ${e.toString()}');
    }
  }
}
