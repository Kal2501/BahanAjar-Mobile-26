import 'package:flutter/material.dart';
import 'package:pertemuan3stls/models/product.dart';
import 'package:pertemuan3stls/widgets/cartProductCard.dart';
import 'package:pertemuan3stls/widgets/productCard.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    required this.products,
    required this.cartQuantities,
    required this.onQuantityChanged,
    required this.grandTotal,
    required this.onCheckout,
    super.key,
  });

  final List<Product> products;
  final Map<String, int> cartQuantities;
  final void Function(Product product, int quantity) onQuantityChanged;
  final int grandTotal;
  final VoidCallback onCheckout;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String searchQuery = '';

  int get currentGrandTotal => widget.products.fold(0, (total, product) {
    return total + product.price * (widget.cartQuantities[product.id] ?? 0);
  });

  @override
  Widget build(BuildContext context) {
    final cartProducts = widget.products.where((product) {
      return (widget.cartQuantities[product.id] ?? 0) > 0 &&
          product.name.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              child: TextField(
                onChanged: (value) =>
                    setState(() => searchQuery = value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Cari',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  suffixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      right: 32,
                      left: 32,
                      bottom: 120,
                    ),
                    child: Column(
                      children: [
                        for (
                          var index = 0;
                          index < cartProducts.length;
                          index++
                        ) ...[
                          CartProductCard(
                            product: cartProducts[index],
                            quantity:
                                widget.cartQuantities[cartProducts[index].id]!,
                            maxQuantity:
                                widget.cartQuantities[cartProducts[index].id]! +
                                cartProducts[index].stock,
                            onQuantityChanged: (quantity) {
                              widget.onQuantityChanged(
                                cartProducts[index],
                                quantity,
                              );
                              setState(() {});
                            },
                          ),
                          if (index < cartProducts.length - 1)
                            const SizedBox(height: 28),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 10,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Grand Total',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatRupiah(currentGrandTotal),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: currentGrandTotal > 0
                                    ? widget.onCheckout
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.shopping_cart, size: 20),
                                    SizedBox(width: 12),
                                    Text(
                                      'Checkout',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: 1,
        onDestinationSelected: (index) {
          if (index == 0) Navigator.pop(context);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
