import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pertemuan3stls/cartPage.dart';
import 'package:pertemuan3stls/homePage.dart';
import 'package:pertemuan3stls/providers/cart_provider.dart';
import 'package:pertemuan3stls/totalPage.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var selectedIndex = 0;

  void selectPage(int index) {
    if (index < 2) setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      CartPage(
        onCheckout: () {
          final total = context.read<CartProvider>().grandTotal;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TotalPage(grandTotal: total)),
          );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: selectedIndex,
        onDestinationSelected: selectPage,
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
