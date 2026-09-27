import 'package:flutter/material.dart';
import 'package:pertemuan3stls/cartPage.dart';
import 'package:pertemuan3stls/models/product.dart';
import 'package:pertemuan3stls/totalPage.dart';
import 'package:pertemuan3stls/widgets/productCard.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final products = <Product>[
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
  final cartQuantities = <String, int>{};

  void addToCart(Product product) {
    if (product.stock == 0) return;
    setState(() {
      product.stock--;
      cartQuantities[product.id] = (cartQuantities[product.id] ?? 0) + 1;
    });
  }

  void changeQuantity(Product product, int quantity) {
    final currentQuantity = cartQuantities[product.id] ?? 0;
    final maxQuantity = currentQuantity + product.stock;
    final nextQuantity = quantity.clamp(1, maxQuantity);
    setState(() {
      product.stock += currentQuantity - nextQuantity;
      cartQuantities[product.id] = nextQuantity;
    });
  }

  int get grandTotal => products.fold(0, (total, product) {
    return total + product.price * (cartQuantities[product.id] ?? 0);
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: HomePage(
        products: products,
        onAddToCart: addToCart,
        onOpenCart: () {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (_) => CartPage(
                products: products,
                cartQuantities: cartQuantities,
                onQuantityChanged: changeQuantity,
                grandTotal: grandTotal,
                onCheckout: () {
                  navigatorKey.currentState!.push(
                    MaterialPageRoute(
                      builder: (_) => TotalPage(grandTotal: grandTotal),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    required this.products,
    required this.onAddToCart,
    required this.onOpenCart,
    super.key,
  });

  final List<Product> products;
  final ValueChanged<Product> onAddToCart;
  final VoidCallback onOpenCart;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final visibleProducts = widget.products.where((product) {
      return product.stock > 0 &&
          product.name.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                              widget.onAddToCart(visibleProducts[index]),
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
      ),
      bottomNavigationBar: _NavigationBar(
        selectedIndex: 0,
        onCartTap: widget.onOpenCart,
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

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({required this.selectedIndex, required this.onCartTap});

  final int selectedIndex;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.white,
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        if (index == 1) onCartTap();
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart),
          label: 'Keranjang',
        ),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
