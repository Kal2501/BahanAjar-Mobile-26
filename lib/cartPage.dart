import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pertemuan3stls/providers/cart_provider.dart';
import 'package:pertemuan3stls/widgets/cartProductCard.dart';
import 'package:pertemuan3stls/widgets/productCard.dart';

class CartPage extends StatefulWidget {
  const CartPage({required this.onCheckout, super.key});

  final VoidCallback onCheckout;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final cartProducts = cart.products.where((product) {
          return (cart.cartQuantities[product.id] ?? 0) > 0 &&
              product.name.toLowerCase().contains(searchQuery);
        }).toList();

        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 28,
                ),
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
                                  cart.cartQuantities[cartProducts[index].id]!,
                              maxQuantity:
                                  cart.cartQuantities[cartProducts[index].id]! +
                                  cartProducts[index].stock,
                              onQuantityChanged: (quantity) =>
                                  cart.changeQuantity(
                                    cartProducts[index],
                                    quantity,
                                  ),
                              onRemove: () =>
                                  cart.removeFromCart(cartProducts[index]),
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
                                    formatRupiah(cart.grandTotal),
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
                                  onPressed: cart.grandTotal > 0
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
        );
      },
    );
  }
}
