import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pertemuan3stls/models/product.dart';
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
          return product.name.toLowerCase().contains(searchQuery);
        }).toList();

        return SafeArea(
          child: Column(
            children: [
              _SearchField(
                onChanged: (value) =>
                    setState(() => searchQuery = value.toLowerCase()),
              ),
              Expanded(
                child: _ProductContent(cart: cart, products: visibleProducts),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductContent extends StatelessWidget {
  const _ProductContent({required this.cart, required this.products});

  final CartProvider cart;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (cart.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cart.loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Produk tidak dapat dimuat dari Firebase.\n${cart.loadError}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return const Center(child: Text('Belum ada produk yang tersedia.'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            for (var index = 0; index < products.length; index++) ...[
              ProductCard(
                product: products[index],
                onAddToCart: () => cart.addToCart(products[index]),
              ),
              if (index < products.length - 1) const SizedBox(height: 28),
            ],
          ],
        ),
      ),
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
