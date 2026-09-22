# Project E-Commerce

Project ini memuat beberapa fungsi umum dari sebuah e-commerce. Project ini dibuat sebagai studi kasus dari Praktikum Pemrograman Piranti Bergerak 2026

## Pertemuan 3 - Widget Lanjutan & Navigation

### Langkah-langkah pengerjaan
- Jika pada praktikum sebelumnya kalian melakukan flutter clean, jalankan flutter pub get pada saat praktikum dimulai
- Ke main.dart di repo ini, copy line bottomNavigationBar. Atau copy code dibawah ini:
  '''
  bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: 0,

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
  '''
- Setelah itu buat file dart dengan nama cartPage.dart
- Copy code di file cartPage.dart (Penjelasan tentang code ada pada praktikum)
- Didalam folder widgets yang kalian buat di lib, buatlah file dart dengan nama cartProductCard.dart
- Copy code di file cartProductCard.dart di folder widgets pada repo ini (Penjelasan tentang code ada di praktikum)

### NOTES
- Diharapkan praktikan tetap membuat atau menyalin code satu per satu.
- Mengikuti langkah-langkah agar tidak terjadi kesalahan pada code.
- Menyimak penjelasan aslab dengan seksama
