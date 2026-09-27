class Product {
  Product({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.stock,
    required this.description,
    required this.price,
  });

  final String id;
  final String imagePath;
  final String name;
  int stock;
  final String description;
  final int price;
}
