import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/product_form.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showProductForm = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).setCurrentView('home');
            },
            child: const Text('View Store'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Products'),
            Tab(text: 'Orders'),
            Tab(text: 'Users'),
          ],
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return Stack(
            children: [
              TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(appProvider),
                  _buildProductsTab(appProvider),
                  _buildOrdersTab(),
                  _buildUsersTab(),
                ],
              ),
              if (_showProductForm)
                ProductForm(
                  onClose: () {
                    setState(() {
                      _showProductForm = false;
                    });
                  },
                  onSave: (shoe) {
                    appProvider.addShoe(shoe);
                    setState(() {
                      _showProductForm = false;
                    });
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(AppProvider appProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Stats Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Total Products',
                appProvider.shoes.length.toString(),
                Icons.inventory,
                Colors.blue,
              ),
              _buildStatCard(
                'Total Orders',
                '1,234',
                Icons.shopping_cart,
                Colors.green,
              ),
              _buildStatCard(
                'Active Users',
                '892',
                Icons.people,
                Colors.orange,
              ),
              _buildStatCard(
                'Revenue',
                '\$54,238',
                Icons.trending_up,
                Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Orders
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Orders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Text('#${1234 + index}'),
                        ),
                        title: Text('Order #${1234 + index}'),
                        subtitle: const Text('John Doe - Air Max Revolution'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Delivered',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab(AppProvider appProvider) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Product Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _showProductForm = true;
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              ),
            ],
          ),
        ),

        // Products List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: appProvider.shoes.length,
            itemBuilder: (context, index) {
              final shoe = appProvider.shoes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      shoe.images.first,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                  title: Text(shoe.name),
                  subtitle: Text('${shoe.brand} - \$${shoe.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Edit product
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          _showDeleteDialog(appProvider, shoe.id);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
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
  }

  Widget _buildOrdersTab() {
    return const Center(
      child: Text(
        'Orders Management\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return const Center(
      child: Text(
        'Users Management\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '+12%',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
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
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(AppProvider appProvider, String shoeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appProvider.deleteShoe(shoeId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}