# Project E-Commerce

Mengubah kode awal yang masih statis menjadi aplikasi yang memiliki state produk, stok, keranjang, pencarian, grand total, dan checkout.

# Langkah-Langkah

## 1. Membuat model produk dan state utama

### File yang dibuka

```text
lib/main.dart
```

Buat file baru:

```text
lib/models/product.dart
```

### Sebelum

Pada kode awal, `ProductCard` langsung berisi teks tetap seperti:

```dart
'Nama Produk'
'Deskripsi Singkat'
'Rp12.000.000'
```

Dan `MainApp` masih berupa:

```dart
class MainApp extends StatelessWidget {
```

### Ganti menjadi

Isi `lib/models/product.dart` dengan:

```dart
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
}
```

Pada `main.dart`, ubah `MainApp` menjadi:

```dart
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
```

Tambahkan import:

```dart
import 'package:pertemuan3stls/models/product.dart';
```

Tambahkan data produk dan keranjang di dalam `_MainAppState`:

```dart
final products = <Product>[
  Product(
    id: 'produk-1',
    imagePath: 'assets/product.png',
    name: 'Produk Satu',
    stock: 5,
    description: 'Deskripsi singkat produk satu',
    price: 12000000,
  ),
];

final cartQuantities = <String, int>{};
```

### Fungsi

`Product` menjadi tempat data produk. `MainApp` menjadi pemilik state utama sehingga perubahan stok dan keranjang dapat memanggil `setState()`.

Untuk menambah produk, tambahkan objek `Product` baru ke list `products`.

## 2. Menambahkan fungsi stok, keranjang, dan grand total

### File yang dibuka

```text
lib/main.dart
```

Tambahkan di dalam `_MainAppState`.

### Sebelum

Tombol pada `ProductCard` masih kosong:

```dart
onPressed: () {},
```

Total pada keranjang masih berupa nilai tetap:

```dart
'Rp12.000.000'
```

### Ganti menjadi

```dart
void addToCart(Product product) {
  if (product.stock == 0) return;

  setState(() {
    product.stock--;
    cartQuantities[product.id] =
        (cartQuantities[product.id] ?? 0) + 1;
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
  return total +
      product.price * (cartQuantities[product.id] ?? 0);
});
```

### Fungsi

- `addToCart()` mengurangi stok dan menambah jumlah produk di keranjang.
- `changeQuantity()` mengubah jumlah pembelian tanpa melewati stok.
- `grandTotal` menghitung harga dikali jumlah setiap produk.

## 3. Mengubah `HomePage` menjadi halaman dinamis

### File yang dibuka

```text
lib/main.dart
```

### Sebelum

Pada kode awal, `HomePage` dipanggil tanpa data:

```dart
home: const HomePage(),
```

Daftar produk juga ditulis berulang:

```dart
const ProductCard(),
const SizedBox(height: 28),
const ProductCard(),
```

### Ganti menjadi

Ubah constructor `HomePage` menjadi:

```dart
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
```

Di `_HomePageState`, tambahkan:

```dart
String searchQuery = '';
```

Di awal `build()`, tambahkan filter:

```dart
final visibleProducts = widget.products.where((product) {
  return product.stock > 0 &&
      product.name.toLowerCase().contains(searchQuery);
}).toList();
```

Ganti daftar `ProductCard` menjadi:

```dart
for (var index = 0; index < visibleProducts.length; index++) ...[
  ProductCard(
    product: visibleProducts[index],
    onAddToCart: () =>
        widget.onAddToCart(visibleProducts[index]),
  ),
  if (index < visibleProducts.length - 1)
    const SizedBox(height: 28),
]
```

Pada `TextField` search, tambahkan:

```dart
onChanged: (value) {
  setState(() {
    searchQuery = value.toLowerCase();
  });
},
```

Pada `MaterialApp`, kirim data ke `HomePage`:

```dart
home: HomePage(
  products: products,
  onAddToCart: addToCart,
  onOpenCart: () {
    // Navigasi ke CartPage ditambahkan pada langkah 4.
  },
),
```

### Fungsi

- Produk dengan stok `0` tidak ditampilkan.
- Search mencari berdasarkan nama produk.
- Tombol pada kartu mengirim produk ke `addToCart()`.

## 4. Mengubah `ProductCard` agar menerima data

### File yang dibuka

```text
lib/widgets/productCard.dart
```

### Sebelum

```dart
const ProductCard({super.key});
```

Isi kartu masih memakai data tetap dan tombolnya belum memiliki aksi.

### Ganti menjadi

Tambahkan import:

```dart
import 'package:pertemuan3stls/models/product.dart';
```

Ubah constructor:

```dart
const ProductCard({
  required this.product,
  required this.onAddToCart,
  super.key,
});

final Product product;
final VoidCallback onAddToCart;
```

Ganti data tetap:

```dart
'Nama Produk'
'Deskripsi Singkat'
'Rp12.000.000'
```

menjadi:

```dart
product.name
product.description
formatRupiah(product.price)
```

Tambahkan stok:

```dart
' Stok: ${product.stock}'
```

Ganti tombol:

```dart
onPressed: () {},
```

menjadi:

```dart
onPressed: product.stock > 0 ? onAddToCart : null,
```

Tambahkan fungsi format harga di bawah class:

```dart
String formatRupiah(int value) {
  final digits = value.toString();
  final groups = <String>[];

  for (var end = digits.length; end > 0; end -= 3) {
    final start = end - 3 < 0 ? 0 : end - 3;
    groups.insert(0, digits.substring(start, end));
  }

  return 'Rp${groups.join('.')}';
}
```

### Fungsi

`ProductCard` sekarang hanya menampilkan data yang diterima dari `HomePage` dan mengirim aksi tombol melalui callback.

## 5. Mengubah `CartPage` dan daftar keranjang

### File yang dibuka

```text
lib/cartPage.dart
```

### Sebelum

```dart
class CartPage extends StatelessWidget {
  const CartPage({super.key});
```

Daftar keranjang masih statis:

```dart
const CartProductCard(),
const SizedBox(height: 28),
const CartProductCard(),
```

### Ganti menjadi

Tambahkan import:

```dart
import 'package:pertemuan3stls/models/product.dart';
```

Ubah `CartPage` menjadi:

```dart
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
```

Di `_CartPageState`, tambahkan:

```dart
String searchQuery = '';

int get currentGrandTotal => widget.products.fold(0, (total, product) {
  return total +
      product.price * (widget.cartQuantities[product.id] ?? 0);
});
```

Di awal `build()`, buat daftar produk keranjang:

```dart
final cartProducts = widget.products.where((product) {
  return (widget.cartQuantities[product.id] ?? 0) > 0 &&
      product.name.toLowerCase().contains(searchQuery);
}).toList();
```

Ganti daftar `CartProductCard` menjadi:

```dart
for (var index = 0; index < cartProducts.length; index++) ...[
  CartProductCard(
    product: cartProducts[index],
    quantity: widget.cartQuantities[cartProducts[index].id]!,
    maxQuantity: widget.cartQuantities[cartProducts[index].id]! +
        cartProducts[index].stock,
    onQuantityChanged: (quantity) {
      widget.onQuantityChanged(cartProducts[index], quantity);
      setState(() {});
    },
  ),
  if (index < cartProducts.length - 1)
    const SizedBox(height: 28),
]
```

Pada search `TextField`, tambahkan:

```dart
onChanged: (value) {
  setState(() {
    searchQuery = value.toLowerCase();
  });
},
```

Pada overlay total, ganti:

```dart
'Rp12.000.000'
```

menjadi:

```dart
formatRupiah(currentGrandTotal)
```

Dan ganti tombol checkout:

```dart
onPressed: () {},
```

menjadi:

```dart
onPressed: currentGrandTotal > 0
    ? widget.onCheckout
    : null,
```

### Fungsi

`CartPage` sekarang hanya menampilkan produk yang benar-benar ada di keranjang, dapat mencari nama produk, menerima perubahan jumlah, dan memperbarui grand total.

## 6. Mengubah `CartProductCard` untuk input jumlah

### File yang dibuka

```text
lib/widgets/cartProductCard.dart
```

### Sebelum

```dart
class CartProductCard extends StatelessWidget {
  const CartProductCard({super.key});
```

Input jumlah belum terhubung ke state dan data produk masih tetap.

### Ganti menjadi

Tambahkan import:

```dart
import 'package:pertemuan3stls/models/product.dart';
import 'package:pertemuan3stls/widgets/productCard.dart';
```

Ubah menjadi `StatefulWidget`:

```dart
class CartProductCard extends StatefulWidget {
  const CartProductCard({
    required this.product,
    required this.quantity,
    required this.maxQuantity,
    required this.onQuantityChanged,
    super.key,
  });

  final Product product;
  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onQuantityChanged;

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}
```

Di `_CartProductCardState`, tambahkan controller dan handler:

```dart
late final TextEditingController quantityController;

@override
void initState() {
  super.initState();
  quantityController =
      TextEditingController(text: '${widget.quantity}');
}

void updateQuantity(String value) {
  final parsed = int.tryParse(value);
  if (parsed == null || parsed < 1) return;

  widget.onQuantityChanged(
    parsed.clamp(1, widget.maxQuantity),
  );
}

@override
void dispose() {
  quantityController.dispose();
  super.dispose();
}
```

Pada `TextField` jumlah, tambahkan:

```dart
controller: quantityController,
onChanged: updateQuantity,
```

Ganti data tetap menjadi:

```dart
widget.product.name
widget.product.description
formatRupiah(widget.product.price)
```

Dan gambar menjadi:

```dart
Image.asset(
  widget.product.imagePath,
  width: 120,
  height: 120,
  fit: BoxFit.cover,
)
```

Hapus tombol `Masukkan Keranjang` dari kartu ini. Tombol tersebut hanya digunakan pada `ProductCard` di beranda.

### Fungsi

Input jumlah mengirim nilai baru ke `CartPage`, lalu `MainApp` menyesuaikan stok dan grand total.

## 7. Menghubungkan navigasi checkout dan `TotalPage`

### File yang dibuka

```text
lib/main.dart
lib/totalPage.dart
```

### Sebelum

Navigasi dari beranda masih berupa:

```dart
home: const HomePage(),
```

Dan tombol checkout masih kosong:

```dart
onPressed: () {},
```

### Ganti menjadi

Pada `main.dart`, ubah `home` menjadi:

```dart
home: HomePage(
  products: products,
  onAddToCart: addToCart,
  onOpenCart: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          products: products,
          cartQuantities: cartQuantities,
          onQuantityChanged: changeQuantity,
          grandTotal: grandTotal,
          onCheckout: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TotalPage(grandTotal: grandTotal),
              ),
            );
          },
        ),
      ),
    );
  },
),
```

Buat file:

```text
lib/totalPage.dart
```

Tambahkan:

```dart
import 'package:flutter/material.dart';
import 'package:pertemuan3stls/widgets/productCard.dart';

class TotalPage extends StatelessWidget {
  const TotalPage({required this.grandTotal, super.key});

  final int grandTotal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Terima kasih sudah checkout!'),
            Text(formatRupiah(grandTotal)),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Fungsi

Checkout membuka halaman baru dan menampilkan grand total sebenarnya, bukan nilai tetap.

## 8. Memastikan asset dan menjalankan project

### File yang dibuka

```text
pubspec.yaml
```

Pastikan terdapat:

```yaml
flutter:
  assets:
    - assets/
```

Struktur asset:

```text
assets/
└── product.png
```

Jalankan:

```bash
flutter pub get
flutter analyze
flutter run
```

## Struktur akhir project

```text
project/
├── assets/
│   └── product.png
├── lib/
│   ├── main.dart
│   ├── cartPage.dart
│   ├── totalPage.dart
│   ├── models/
│   │   └── product.dart
│   └── widgets/
│       ├── productCard.dart
│       └── cartProductCard.dart
└── pubspec.yaml
```

## Ringkasan fungsi

| Perubahan | Fungsi |
| --- | --- |
| `Product` | Menyimpan data produk dan stok |
| `MainApp extends StatefulWidget` | Menyimpan state produk dan keranjang |
| `addToCart()` | Mengurangi stok dan menambah isi keranjang |
| `changeQuantity()` | Mengubah jumlah dan menyesuaikan stok |
| `searchQuery` | Mencari produk berdasarkan nama |
| `grandTotal` | Menghitung harga dikali jumlah |
| `ProductCard` | Menampilkan produk dan tombol tambah keranjang |
| `CartProductCard` | Menampilkan produk keranjang dan input jumlah |
| `TotalPage` | Menampilkan pesan checkout dan grand total |
