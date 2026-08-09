import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/app_data_manager.dart';
import '../providers/product_provider.dart';
import '../utils/app_colors.dart';
import '../utils/formatter.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppDataManager get _mgr => AppDataManager.instance;
  late GoogleMapController _mapController;

  // Lokasi distributor pusat Tanian (contoh: Jakarta)
  final LatLng distributorLocation = const LatLng(-6.2088, 106.8456);

  @override
  void initState() {
    super.initState();
    ProductProvider.instance.loadProducts().then((_) {
      if (mounted) setState(() {});
    });
  }

  // ... fungsi _showEditProfile, _showAbout, _confirmLogout tetap sama ...

  @override
  Widget build(BuildContext context) {
    final prov = ProductProvider.instance;
    final totalProduk = prov.products.length;
    final trendNaik = prov.trendUpCount;
    final totalRevenue = prov.totalRevenue;

    final String displayName =
        _mgr.name.isNotEmpty ? _mgr.name : 'Pemilik UMKM';
    final String initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'T';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER PROFIL
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Profil UMKM',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.surface)),
                        IconButton(
                          onPressed: _showEditProfile,
                          icon: const Icon(Icons.edit_outlined,
                              color: AppColors.surface, size: 20),
                          tooltip: 'Edit Profil',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.surface.withValues(alpha: 0.4),
                            width: 2.5),
                      ),
                      child: Center(
                        child: Text(initial,
                            style: GoogleFonts.poppins(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: AppColors.surface)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(_mgr.namaUmkm,
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.surface)),
                    const SizedBox(height: 4),
                    Text(
                      _mgr.name.isNotEmpty
                          ? 'Pemilik: ${_mgr.name}'
                          : 'Distribusi Pertanian Lokal Indonesia',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.surface.withValues(alpha: 0.85)),
                    ),
                  ]),
                ),
              ),
            ),

            // STATS SINGKAT
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _quickStat('$totalProduk', 'Produk'),
                      _quickStat('$trendNaik', 'Tren Naik'),
                      _quickStat(Formatter.currency(totalRevenue), 'Omzet'),
                    ],
                  ),
                ),
              ),
            ),

            // INFORMASI DETAIL
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Informasi UMKM',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  _infoCard([
                    _infoItem(Icons.person_outline, 'Nama Pemilik',
                        _mgr.name.isNotEmpty ? _mgr.name : '-'),
                    _infoItem(Icons.email_outlined, 'Email',
                        _mgr.email.isNotEmpty ? _mgr.email : '-'),
                    _infoItem(Icons.phone_outlined, 'Nomor HP',
                        _mgr.phone.isNotEmpty ? _mgr.phone : '-'),
                    _infoItem(Icons.location_on_outlined, 'Alamat',
                        _mgr.address.isNotEmpty ? _mgr.address : '-'),
                  ]),
                  const SizedBox(height: 20),

                  // Tentang Usaha
                  Text('Tentang Usaha',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(_mgr.deskripsi,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.6)),
                  ),
                  const SizedBox(height: 20),

                  // Lokasi Distributor Pusat
                  Text('Lokasi Distributor Pusat',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: distributorLocation,
                        zoom: 12,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('tanian_distributor'),
                          position: distributorLocation,
                          infoWindow: const InfoWindow(
                              title: 'Distributor Pusat Tanian'),
                        ),
                      },
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Menu lainnya + logout tetap sama...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // helper widget _quickStat, _infoCard, _infoItem, dll tetap sama
}
