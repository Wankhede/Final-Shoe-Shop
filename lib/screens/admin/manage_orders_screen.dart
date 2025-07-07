import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderProvider.orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderProvider.orders.length,
            itemBuilder: (context, index) {
              final order = orderProvider.orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      _getStatusIcon(order.status),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Order #${order.id.substring(0, 8)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                      Text('Date: ${DateFormat('MMM dd, yyyy').format(order.orderDate)}'),
                      Row(
                        children: [
                          Text('Status: '),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              order.status.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (order.isDelayed) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'DELAYED',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order Items
                          const Text(
                            'Items:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text('${item.productName} x${item.quantity}'),
                                ),
                                Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                              ],
                            ),
                          )),
                          const Divider(),
                          
                          // Delivery Address
                          const Text(
                            'Delivery Address:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(order.deliveryAddress.name),
                          Text(order.deliveryAddress.address),
                          Text('Pincode: ${order.deliveryAddress.pincode}'),
                          Text('Phone: ${order.deliveryAddress.phone}'),
                          const SizedBox(height: 16),
                          
                          // Status Update Buttons
                          if (order.status != 'delivered' && order.status != 'cancelled')
                            Row(
                              children: [
                                if (order.status == 'pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      _updateOrderStatus(context, orderProvider, order.id, 'shipped');
                                    },
                                    child: const Text('Mark as Shipped'),
                                  ),
                                if (order.status == 'shipped') ...[
                                  ElevatedButton(
                                    onPressed: () {
                                      _updateOrderStatus(context, orderProvider, order.id, 'delivered');
                                    },
                                    child: const Text('Mark as Delivered'),
                                  ),
                                ],
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () {
                                    _updateOrderStatus(context, orderProvider, order.id, 'cancelled');
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Cancel Order'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  void _updateOrderStatus(BuildContext context, OrderProvider orderProvider, String orderId, String status) async {
    final success = await orderProvider.updateOrderStatus(orderId, status);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Order status updated successfully!' : 'Failed to update order status'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}