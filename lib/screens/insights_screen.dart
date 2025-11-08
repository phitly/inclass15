import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';

class InsightsScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Insights'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<Item>>(
        stream: _firestoreService.getItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No inventory data available'));
          }

          final items = snapshot.data!;
          final totalItems = items.length;
          final totalValue = items.fold<double>(
            0,
            (sum, item) => sum + (item.quantity * item.price),
          );
          final outOfStockItems = items.where((item) => item.quantity == 0).toList();
          final lowStockItems = items.where((item) => item.quantity > 0 && item.quantity < 10).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Items',
                        totalItems.toString(),
                        Icons.inventory_2,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Total Value',
                        '\$${totalValue.toStringAsFixed(2)}',
                        Icons.attach_money,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Out of Stock',
                        outOfStockItems.length.toString(),
                        Icons.warning,
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Low Stock',
                        lowStockItems.length.toString(),
                        Icons.error_outline,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Out of Stock Items
                if (outOfStockItems.isNotEmpty) ...[
                  const Text(
                    'Out of Stock Items',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: outOfStockItems.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = outOfStockItems[index];
                        return ListTile(
                          leading: const Icon(Icons.error, color: Colors.red),
                          title: Text(item.name),
                          subtitle: Text(item.category),
                          trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Low Stock Items
                if (lowStockItems.isNotEmpty) ...[
                  const Text(
                    'Low Stock Items (< 10)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lowStockItems.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = lowStockItems[index];
                        return ListTile(
                          leading: const Icon(Icons.warning_amber, color: Colors.orange),
                          title: Text(item.name),
                          subtitle: Text('${item.category} - Qty: ${item.quantity}'),
                          trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ),
                ],

                // Category Breakdown
                const SizedBox(height: 24),
                const Text(
                  'Category Breakdown',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildCategoryBreakdown(items),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(List<Item> items) {
    final categoryMap = <String, int>{};
    for (var item in items) {
      categoryMap[item.category] = (categoryMap[item.category] ?? 0) + 1;
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categoryMap.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final category = categoryMap.keys.elementAt(index);
          final count = categoryMap[category]!;
          return ListTile(
            leading: const Icon(Icons.category),
            title: Text(category),
            trailing: Chip(
              label: Text('$count items'),
            ),
          );
        },
      ),
    );
  }
}
