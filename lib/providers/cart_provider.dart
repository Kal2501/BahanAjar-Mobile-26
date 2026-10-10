import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pertemuan3stls/models/product.dart';

class CartProvider extends ChangeNotifier {
  CartProvider({FirebaseFirestore? firestore, List<Product>? initialProducts})
    : _firestore =
          firestore ??
          (initialProducts == null ? FirebaseFirestore.instance : null) {
    if (initialProducts != null) {
      products.addAll(initialProducts);
      isLoading = false;
    } else {
      _subscribeToProducts();
    }
  }

  final FirebaseFirestore? _firestore;
  final List<Product> products = [];
  final Map<String, int> cartQuantities = {};
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _productsSubscription;
  Object? loadError;
  bool isLoading = true;

  int get grandTotal => products.fold(0, (total, product) {
    return total + product.price * (cartQuantities[product.id] ?? 0);
  });

  void _subscribeToProducts() {
    _productsSubscription = _firestore!
        .collection('products')
        .orderBy('name')
        .snapshots()
        .listen(
          (snapshot) {
            try {
              final nextProducts = snapshot.docs
                  .map(Product.fromFirestore)
                  .toList();
              products
                ..clear()
                ..addAll(nextProducts);
              final productIds = products.map((product) => product.id).toSet();
              cartQuantities.removeWhere(
                (productId, _) => !productIds.contains(productId),
              );
              loadError = null;
              isLoading = false;
              notifyListeners();
            } on Object catch (error) {
              loadError = error;
              isLoading = false;
              notifyListeners();
            }
          },
          onError: (Object error) {
            loadError = error;
            isLoading = false;
            notifyListeners();
          },
        );
  }

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

  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }
}
