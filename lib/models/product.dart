class ProductCategory {
  final int id;
  final String name;
  final String image;
  final String slug;

  ProductCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.slug,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      slug: json['slug'],
    );
  }
}

class Product {
  final int id;
  final String title;
  final String slug;
  final int price;
  final String description;
  final ProductCategory category;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      price: json['price'],
      description: json['description'],
      category: ProductCategory.fromJson(json['category']),
      images: List<String>.from(json['images']),
    );
  }

  String get primaryImage =>
      images.isNotEmpty ? images[0] : 'https://placehold.co/600x400';
}
