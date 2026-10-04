import 'package:flutter/foundation.dart';
import 'package:pertemuan3stls/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> products = [
    Product(
      id: 'produk-1',
      imagePath: 'assets/product.png',
      name: 'Produk Satu',
      stock: 5,
      description: 'Deskripsi singkat produk satu',
      price: 12000000,
    ),
    Product(
      id: 'produk-2',
      imagePath: 'assets/product.png',
      name: 'Produk Dua',
      stock: 4,
      description: 'Deskripsi singkat produk dua',
      price: 8500000,
    ),
    Product(
      id: 'produk-3',
      imagePath: 'assets/product.png',
      name: 'Produk Tiga',
      stock: 3,
      description: 'Deskripsi singkat produk tiga',
      price: 6500000,
    ),
    Product(
      id: 'produk-4',
      imagePath: 'assets/product.png',
      name: 'Produk Empat',
      stock: 2,
      description: 'Deskripsi singkat produk empat',
      price: 4500000,
    ),
    Product(
      id: 'produk-5',
      imagePath: 'assets/product.png',
      name: 'Produk Lima',
      stock: 1,
      description: 'Deskripsi singkat produk lima',
      price: 3000000,
    ),
  ];

  final Map<String, int> cartQuantities = {};

  int get grandTotal => products.fold(0, (total, product) {
    return total + product.price * (cartQuantities[product.id] ?? 0);
  });

  void addToCart(Product product) {
    if (product.stock == 0) return;
    product.stock--;
    cartQuantities[product.id] = (cartQuantities[product.id] ?? 0) + 1;
    notifyListeners();
  }

  void changeQuantity(Product product, int quantity) {
    final currentQuantity = cartQuantities[product.id] ?? 0;
    final maxQuantity = currentQuantity + product.stock;
    final nextQuantity = quantity.clamp(1, maxQuantity);
    product.stock += currentQuantity - nextQuantity;
    cartQuantities[product.id] = nextQuantity;
    notifyListeners();
  }

  void removeFromCart(Product product) {
    final currentQuantity = cartQuantities.remove(product.id) ?? 0;
    product.stock += currentQuantity;
    notifyListeners();
  }
}
