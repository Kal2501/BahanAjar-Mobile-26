// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:pertemuan3stls/main.dart';
import 'package:pertemuan3stls/providers/cart_provider.dart';

void main() {
  testWidgets('produk dapat ditambahkan ke keranjang', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: const MainApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Produk Satu'), findsOneWidget);
    await tester.tap(find.text('Masukkan Keranjang').first);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.shopping_cart).last);
    await tester.pump();
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });
}
