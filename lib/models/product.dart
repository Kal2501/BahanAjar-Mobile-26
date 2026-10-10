import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    if (data == null) {
      throw FormatException('Data produk ${document.id} kosong.');
    }

    final name = data['name'];
    final price = data['price'];
    final stock = data['stock'];
    final description = data['description'];

    if (name is! String ||
        price is! num ||
        stock is! num ||
        description is! String) {
      throw FormatException(
        'Produk ${document.id} harus memiliki name, price, stock, '
        'dan description dengan tipe yang benar.',
      );
    }

    final imagePath = data['imagePath'] ?? data['imageUrl'] ?? 'assets/product.png';
    if (imagePath is! String) {
      throw FormatException('imagePath produk ${document.id} harus berupa teks.');
    }

    return Product(
      id: document.id,
      imagePath: imagePath,
      name: name,
      stock: stock.toInt(),
      description: description,
      price: price.toInt(),
    );
  }
}
