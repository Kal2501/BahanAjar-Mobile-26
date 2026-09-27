# Project E-Commerce

Project ini memuat beberapa fungsi umum dari sebuah e-commerce. Project ini dibuat sebagai studi kasus dari Praktikum Pemrograman Piranti Bergerak 2026

## Pertemuan 3 - Widget Lanjutan & Navigation

# Langkah-Langkah

## 1. Mengatur `selectedIndex` pada `HomePage`
Jika pada praktikum sebelumnya kalian melakukan flutter clean, jalankan flutter pub get pada saat praktikum dimulai

Pada file `main.dart`, `HomePage` merupakan halaman **Beranda**.

Pada `NavigationBar`, ganti:

```dart
selectedIndex: _currentIndex,
```

menjadi:

```dart
selectedIndex: 0,
```

## 2. Menambahkan `onDestinationSelected` pada `HomePage`

Masih pada file `main.dart`, tambahkan `onDestinationSelected` setelah `selectedIndex`:

```dart
onDestinationSelected: (index) {
  if (index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartPage(),
      ),
    );
  }
},
```

## 3. Menghapus `_currentIndex`

Hapus kode:

```dart
int _currentIndex = 0;
```

## 4. Membuat File `cartPage.dart`

Buat file baru bernama:

```
cartPage.dart
```

Letakkan file tersebut di dalam folder `lib`.

Struktur folder:

```
lib/
├── main.dart
├── cartPage.dart
└── widgets/
    └── productCard.dart
```

## 5. Menambahkan Import pada `cartPage.dart`

Pada file `cartPage.dart`, tambahkan:

```dart
import 'package:flutter/material.dart';
import 'package:pertemuan3stls/widgets/cartProductCard.dart';
```

## 6. Membuat `CartPage`

Tambahkan:

```dart
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
```

## 7. Menambahkan `Scaffold`

Ganti:

```dart
return Scaffold();
```

menjadi:

```dart
return Scaffold(
  backgroundColor: Colors.white,
);
```

## 8. Menambahkan `SafeArea` dan `Column`

Tambahkan pada `Scaffold`:

```dart
body: SafeArea(
  child: Column(
    children: [],
  ),
),
```

## 9. Menambahkan Search Bar

Karena tampilan `CartPage` hampir sama dengan `HomePage`, salin bagian Search Bar dari `HomePage` ke dalam `Column`:

```dart
Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 32,
    vertical: 28,
  ),
  child: TextField(
    decoration: InputDecoration(
      hintText: 'Cari',
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
      ),
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Icon(
          Icons.search,
          size: 24,
          color: Colors.grey.shade400,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),
    ),
  ),
),
```

## 10. Menambahkan Daftar Produk pada `CartPage`

Tambahkan `Expanded` dan `Stack` setelah Search Bar:

```dart
Expanded(
  child: Stack(
    children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 32,
            left: 32,
            bottom: 120,
          ),
          child: Column(
            children: [
              const CartProductCard(),

              const SizedBox(height: 28),

              const CartProductCard(),

              const SizedBox(height: 28),

              const CartProductCard(),

              const SizedBox(height: 28),

              const CartProductCard(),
            ],
          ),
        ),
      ),
    ],
  ),
),
```

## 11. Membuat File `cartProductCard.dart`

Buat file baru di dalam folder `widgets`:

```
widgets/
├── productCard.dart
└── cartProductCard.dart
```

## 12. Menyalin `ProductCard` ke `CartProductCard`

Buka file `productCard.dart`.

Salin seluruh isi `ProductCard`, kemudian tempelkan ke file:

```
cartProductCard.dart
```

## 13. Mengubah Nama Class

Pada file `cartProductCard.dart`, ubah:

```dart
class ProductCard extends StatelessWidget {
```

menjadi:

```dart
class CartProductCard extends StatelessWidget {
```

Kemudian ubah constructor:

```dart
const ProductCard({super.key});
```

menjadi:

```dart
const CartProductCard({super.key});
```

## 14. Mengubah Tampilan Gambar Produk

Pada `CartProductCard`, ganti bagian gambar:

```dart
Container(
  width: 120,
  height: 120,
  color: Colors.grey.shade300,
),
```

menjadi:

```dart
Image.asset(
  'assets/product.png',
  width: 120,
  height: 120,
  fit: BoxFit.cover,
),
```

## 15. Mengubah Jarak antara Gambar dan Informasi Produk

Ganti:

```dart
const SizedBox(width: 16),
```

menjadi:

```dart
const SizedBox(width: 28),
```

## 16. Menghapus Tombol Masukkan Keranjang

Pada `CartProductCard`, hapus bagian tombol:

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    minimumSize: const Size(
      double.infinity,
      42,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
  ),
  child: const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.shopping_cart,
        size: 20,
      ),
      SizedBox(width: 8),
      Text(
        'Masukkan Keranjang',
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    ],
  ),
),
```

## 17. Menambahkan Input Jumlah Produk

Setelah informasi harga produk, tambahkan:

```dart
const SizedBox(width: 20),

SizedBox(
  width: 48,
  height: 48,
  child: TextField(
    keyboardType: TextInputType.number,
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      hintText: '1',
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
    ),
  ),
),
```

## 18. Mengubah Struktur `Row` pada `CartProductCard`

Struktur `Row` pada `CartProductCard` menjadi:

```dart
Row(
  children: [
    Image.asset(
      'assets/product.png',
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    ),

    const SizedBox(width: 28),

    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nama Produk',
            style: TextStyle(
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Deskripsi Singkat',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Rp12.000.000',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),

    const SizedBox(width: 20),

    SizedBox(
      width: 48,
      height: 48,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: '1',
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ),
    ),
  ],
),
```

## 19. Menambahkan Asset pada `pubspec.yaml`

Karena `CartProductCard` menggunakan gambar:

```dart
Image.asset(
  'assets/product.png',
)
```

tambahkan folder `assets` pada file `pubspec.yaml`.

Cari bagian:

```yaml
flutter:
```

kemudian tambahkan:

```yaml
flutter:
  assets:
    - assets/
```

## 20. Menyiapkan Folder `assets`

Buat folder `assets` pada root project:

```
project/
├── assets/
│   └── product.png
├── lib/
│   ├── main.dart
│   ├── cartPage.dart
│   └── widgets/
│       ├── productCard.dart
│       └── cartProductCard.dart
└── pubspec.yaml
```

Masukkan file gambar `product.png` ke dalam folder `assets`.

## 21. Menjalankan `flutter pub get`

Setelah mengubah `pubspec.yaml`, jalankan:

```
flutter pub get
```

## 22. Menambahkan `Positioned` pada `CartPage`

Kembali ke file `cartPage.dart`.

Di dalam `Stack`, setelah `SingleChildScrollView`, tambahkan:

```dart
Positioned(
  left: 0,
  right: 0,
  bottom: 0,
  child: Container(),
),
```

## 23. Menambahkan Panel Total

Ganti `Container()` menjadi:

```dart
Container(
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
          children: const [
            Text(
              'Total',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            SizedBox(height: 4),

            Text(
              'Rp12.000.000',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
```

## 24. Menambahkan Tombol

Setelah `Expanded` yang berisi total, tambahkan:

```dart
const SizedBox(width: 20),

Expanded(
  flex: 2,
  child: SizedBox(
    height: 46,
    child: ElevatedButton(
      onPressed: () {},
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
          Icon(
            Icons.shopping_cart,
            size: 20,
          ),

          SizedBox(width: 12),

          Text(
            'Masukkan Keranjang',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  ),
),
```

## 25. Menambahkan `NavigationBar` pada `CartPage`

Tambahkan pada `Scaffold`:

```dart
bottomNavigationBar: NavigationBar(
  backgroundColor: Colors.white,
  selectedIndex: 1,

  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Beranda',
    ),

    NavigationDestination(
      icon: Icon(Icons.shopping_cart),
      label: 'Keranjang',
    ),

    NavigationDestination(
      icon: Icon(Icons.person),
      label: 'Profil',
    ),
  ],
),
```

## 26. Menambahkan Navigasi Kembali ke `HomePage`

Setelah:

```dart
selectedIndex: 1,
```

tambahkan:

```dart
onDestinationSelected: (index) {
  if (index == 0) {
    Navigator.pop(context);
  }
},
```

Sehingga menjadi:

```dart
bottomNavigationBar: NavigationBar(
  backgroundColor: Colors.white,
  selectedIndex: 1,

  onDestinationSelected: (index) {
    if (index == 0) {
      Navigator.pop(context);
    }
  },

  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Beranda',
    ),

    NavigationDestination(
      icon: Icon(Icons.shopping_cart),
      label: 'Keranjang',
    ),

    NavigationDestination(
      icon: Icon(Icons.person),
      label: 'Profil',
    ),
  ],
),
```

## Struktur Akhir Project

```
project/
├── assets/
│   └── product.png
├── lib/
│   ├── main.dart
│   ├── cartPage.dart
│   └── widgets/
│       ├── productCard.dart
│       └── cartProductCard.dart
└── pubspec.yaml
```
### NOTES
- Diharapkan praktikan tetap membuat atau menyalin code satu per satu.
- Mengikuti langkah-langkah agar tidak terjadi kesalahan pada code.
- Menyimak penjelasan aslab dengan seksama

## Page yang dibuat
<img width="780" height="682" alt="image" src="https://github.com/user-attachments/assets/c69f395c-4b21-499c-bdc9-c8dee822af2a" />


