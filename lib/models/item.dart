class Item {
  final String id;
  final String title;
  final String description;
  final String image;
  final double price;
  final String category;
  final bool isFavorite;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    this.isFavorite = false,
  });

  Item copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    double? price,
    String? category,
    bool? isFavorite,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
