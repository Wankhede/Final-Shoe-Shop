import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import 'add_product_screen.dart';
import 'manage_products_screen.dart';
import 'manage_orders_screen.dart';
import '../auth/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
      Provider.of<OrderProvider>(context, listen: false).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    authProvider.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 8),
                        Text(authProvider.user?.name ?? 'Admin'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      authProvider.user?.name.substring(0, 1).toUpperCase() ?? 'A',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            Consumer2<ProductProvider, OrderProvider>(
              builder: (context, productProvider, orderProvider, child) {
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildStatCard(
                      'Total Products',
                      productProvider.products.length.toString(),
                      Icons.inventory,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'Total Orders',
                      orderProvider.totalOrders.toString(),
                      Icons.shopping_cart,
                      Colors.green,
                    ),
                    _buildStatCard(
                      'Pending Orders',
                      orderProvider.pendingOrders.toString(),
                      Icons.pending,
                      Colors.orange,
                    ),
                    _buildStatCard(
                      'Delayed Orders',
                      orderProvider.delayedOrders.length.toString(),
                      Icons.warning,
                      Colors.red,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildActionCard(
                  'Add Product',
                  Icons.add_box,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddProductScreen()),
                    );
                  },
                ),
                _buildActionCard(
                  'Manage Products',
                  Icons.inventory_2,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ManageProductsScreen()),
                    );
                  },
                ),
                _buildActionCard(
                  'Manage Orders',
                  Icons.list_alt,
                  Colors.orange,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ManageOrdersScreen()),
                    );
                  },
                ),
                _buildActionCard(
                  'Low Stock Alert',
                  Icons.warning_amber,
                  Colors.red,
                  () {
                    _showLowStockDialog();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '+12%',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.8), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLowStockDialog() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final lowStockProducts = productProvider.getLowStockProducts();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Low Stock Alert'),
        content: lowStockProducts.isEmpty
            ? const Text('All products are well stocked!')
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: lowStockProducts.length,
                  itemBuilder: (context, index) {
                    final product = lowStockProducts[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('Stock: ${product.stock}'),
                      trailing: Icon(
                        Icons.warning,
                        color: product.stock < 5 ? Colors.red : Colors.orange,
                      ),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}