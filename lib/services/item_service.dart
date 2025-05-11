import '../models/item.dart';

class ItemService {
  static List<Item> getItems() {
    return [
      Item(
        id: '1',
        title: 'Modern Chair',
        description: 'Elegant and comfortable chair for your living room.',
        image: 'assets/images/item1.png',
        price: 149.99,
        category: 'Furniture',
      ),
      Item(
        id: '2',
        title: 'Wireless Headphones',
        description: 'Premium sound quality with noise cancellation.',
        image: 'assets/images/item2.png',
        price: 199.99,
        category: 'Electronics',
      ),
      Item(
        id: '3',
        title: 'Smart Watch',
        description: 'Track your fitness and stay connected on the go.',
        image: 'assets/images/item3.png',
        price: 249.99,
        category: 'Electronics',
      ),
      Item(
        id: '4',
        title: 'Desk Lamp',
        description: 'Adjustable LED lamp with multiple brightness levels.',
        image: 'assets/images/item4.png',
        price: 59.99,
        category: 'Home',
      ),
      Item(
        id: '5',
        title: 'Coffee Table',
        description: 'Modern design with ample storage space.',
        image: 'assets/images/item5.png',
        price: 299.99,
        category: 'Furniture',
      ),
    ];
  }

  static List<Map<String, dynamic>> getCategories() {
    return [
      {'icon': 'assets/images/furniture.png', 'name': 'Furniture'},
      {'icon': 'assets/images/electronics.png', 'name': 'Electronics'},
      {'icon': 'assets/images/fashion.png', 'name': 'Fashion'},
      {'icon': 'assets/images/home.png', 'name': 'Home'},
    ];
  }

  static List<Item> getItemsByCategory(String category) {
    if (category.isEmpty) {
      return getItems();
    }
    return getItems().where((item) => item.category == category).toList();
  }

  static Item? getItemById(String id) {
    try {
      return getItems().firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
