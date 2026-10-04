import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pertemuan3stls/providers/cart_provider.dart';
import 'package:pertemuan3stls/widgets/productCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final visibleProducts = cart.products.where((product) {
          return product.stock > 0 &&
              product.name.toLowerCase().contains(searchQuery);
        }).toList();

        return SafeArea(
          child: Column(
            children: [
              _SearchField(
                onChanged: (value) =>
                    setState(() => searchQuery = value.toLowerCase()),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        for (
                          var index = 0;
                          index < visibleProducts.length;
                          index++
                        ) ...[
                          ProductCard(
                            product: visibleProducts[index],
                            onAddToCart: () =>
                                cart.addToCart(visibleProducts[index]),
                          ),
                          if (index < visibleProducts.length - 1)
                            const SizedBox(height: 28),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Cari',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          suffixIcon: Icon(Icons.search, size: 28, color: Colors.grey.shade400),
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
    );
  }
}
