import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class FirestoreService {
  // Create a reference to the 'items' collection
  final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');

  // Add a new item to Firestore
  Future<void> addItem(Item item) async {
    try {
      await _itemsCollection.add(item.toMap());
    } catch (e) {
      print('Error adding item: $e');
      rethrow;
    }
  }

  // Get a stream of all items from Firestore
  Stream<List<Item>> getItemsStream() {
    return _itemsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Item.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update an existing item
  Future<void> updateItem(Item item) async {
    if (item.id == null) {
      throw Exception('Item ID cannot be null for update');
    }
    try {
      await _itemsCollection.doc(item.id).update(item.toMap());
    } catch (e) {
      print('Error updating item: $e');
      rethrow;
    }
  }

  // Delete an item by ID
  Future<void> deleteItem(String itemId) async {
    try {
      await _itemsCollection.doc(itemId).delete();
    } catch (e) {
      print('Error deleting item: $e');
      rethrow;
    }
  }

  // Search items by name
  Stream<List<Item>> searchItems(String searchQuery) {
    if (searchQuery.isEmpty) {
      return getItemsStream();
    }
    
    return _itemsCollection
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Item.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .where((item) => item.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  // Filter items by category
  Stream<List<Item>> filterByCategory(String category) {
    if (category.isEmpty || category == 'All') {
      return getItemsStream();
    }
    
    return _itemsCollection
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Item.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get low stock items (quantity < 10)
  Stream<List<Item>> getLowStockItems() {
    return _itemsCollection
        .where('quantity', isLessThan: 10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Item.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Delete multiple items
  Future<void> deleteMultipleItems(List<String> itemIds) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (String id in itemIds) {
        batch.delete(_itemsCollection.doc(id));
      }
      await batch.commit();
    } catch (e) {
      print('Error deleting multiple items: $e');
      rethrow;
    }
  }
}
