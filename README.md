# Tanian Dashboard

## Deskripsi
Tanian Dashboard yang sebelumnya dikembangkan kini ditingkatkan menjadi aplikasi mobile berbasis Flutter.  
Aplikasi ini digunakan oleh pemilik atau pengelola UMKM untuk memantau data produk dan penjualan secara ringkas melalui dashboard yang responsif. Data produk tidak ditulis langsung pada kode program, melainkan diambil secara dinamis dari **REST API** dalam format JSON.

## Tujuan
- Memberikan insight cepat tentang jumlah produk, penjualan, omzet, tren naik, dan stok menipis.  
- Menyediakan akses detail produk dengan integrasi **Google Maps** untuk lokasi distribusi.  
- Mendukung pengelolaan produk (CRUD) dengan foto, kategori, dan stok.  

## Fitur Utama
| Fitur          | Keterangan |
|----------------|------------|
| Splash Screen  | Tampilan awal dengan logo UMKM Insight |
| Autentikasi    | Login, Register, Forgot Password |
| Dashboard      | Ringkasan analisis produk & penjualan |
| Produk         | CRUD Produk (Tambah, Edit, Hapus) |
| Upload Foto    | Menambahkan foto produk |
| Detail Produk  | Menampilkan detail produk dengan integrasi Google Maps |
| Laporan        | Laporan penjualan sederhana |
| Profil         | Informasi UMKM |
| Responsif      | UI mendukung berbagai ukuran layar |
| REST API       | Data produk diambil dari API, parsing JSON ke model OOP, service class, FutureBuilder |

## API
https://my-json-server.typicode.com/strawcrmlss/tanian-api/products

## Struktur Folder
## Struktur Folder

lib/
- screens/
  - dashboard_screen.dart
  - product_screen.dart
  - profile_screen.dart
  - product_detail_screen.dart
  - product_form_screen.dart
- widgets/
  - dashboard_header.dart
  - metric_card.dart
  - sales_list_item.dart
  - product_card.dart
  - quick_stat.dart
- models/
  - product_item.dart
- providers/
  - product_provider.dart
- utils/
  - app_colors.dart
  - formatter.dart


