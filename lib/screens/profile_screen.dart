import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    super.initState();
    // Pastikan data produk tersedia untuk statistik,
    // tanpa perlu membuka tab Beranda terlebih dahulu.
    // loadProducts() cached — tidak double-fetch jika sudah dimuat.
    ProductProvider.instance.loadProducts().then((_) {
      if (mounted) setState(() {});
    });
  }

  void _showEditProfile() {
    final mgr = _mgr;
    final nameCtrl = TextEditingController(text: mgr.name);
    final emailCtrl = TextEditingController(text: mgr.email);
    final phoneCtrl = TextEditingController(text: mgr.phone);
    final addressCtrl = TextEditingController(text: mgr.address);
    final namaUmkmCtrl = TextEditingController(text: mgr.namaUmkm);
    final descCtrl = TextEditingController(text: mgr.deskripsi);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text('Edit Profil UMKM',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              _editField('Nama UMKM', namaUmkmCtrl,
                  icon: Icons.store_outlined),
              const SizedBox(height: 14),
              _editField('Nama Pemilik', nameCtrl,
                  icon: Icons.person_outline),
              const SizedBox(height: 14),
              _editField('Email', emailCtrl,
                  icon: Icons.email_outlined,
                  inputType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              _editField('Nomor HP', phoneCtrl,
                  icon: Icons.phone_outlined,
                  inputType: TextInputType.phone),
              const SizedBox(height: 14),
              _editField('Alamat Lengkap', addressCtrl,
                  icon: Icons.location_on_outlined, maxLines: 2),
              const SizedBox(height: 14),
              _editField('Deskripsi Usaha', descCtrl,
                  icon: Icons.description_outlined, maxLines: 3),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    _mgr.updateProfile(
                      name: nameCtrl.text,
                      email: emailCtrl.text,
                      phone: phoneCtrl.text,
                      address: addressCtrl.text,
                      namaUmkm: namaUmkmCtrl.text,
                      deskripsi: descCtrl.text,
                    );
                    setState(() {});
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Profil berhasil diperbarui'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  child: const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.eco_rounded,
                color: AppColors.surface, size: 20),
          ),
          const SizedBox(width: 12),
          Text('Tanian Dashboard',
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w700)),
        ]),
        content: Text(
          'Tanian Dashboard adalah aplikasi monitoring produk dan penjualan '
          'untuk UMKM distribusi pertanian lokal Indonesia.\n\n'
          'Versi: 1.0.0\n'
          'Platform: Flutter (Material 3)\n'
          'Data: REST API — My JSON Server\n\n'
          'Dibuat untuk memenuhi tugas mata kuliah Mobile Programming — '
          'UMKM Insight Dashboard (Pertemuan 9–10).',
          style: GoogleFonts.inter(
              fontSize: 12, color: AppColors.textSecondary, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Keluar Akun?',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, fontSize: 16)),
        content: Text(
          'Anda yakin ingin keluar dari akun Tanian Dashboard?',
          style: GoogleFonts.inter(
              fontSize: 13, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal',
                style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _mgr.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: Text('Keluar',
                style: GoogleFonts.inter(
                    color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Baca langsung dari ProductProvider — sudah ter-load via initState
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
            // ── HEADER PROFIL ─────────────────────────────────────
            Container(
              width: double.infinity,
              decoration:
                  const BoxDecoration(gradient: AppColors.primaryGradient),
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
                          style: IconButton.styleFrom(
                            backgroundColor:
                                AppColors.surface.withValues(alpha: 0.2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
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
                    if (_mgr.email.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(_mgr.email,
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              color:
                                  AppColors.surface.withValues(alpha: 0.7))),
                    ],
                  ]),
                ),
              ),
            ),

            // ── STATS SINGKAT — sinkron dengan ProductProvider ────
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color:
                              AppColors.textPrimary.withValues(alpha: 0.08),
                          blurRadius: 16)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Produk — sinkron dengan Dashboard
                      _quickStat('$totalProduk', 'Produk'),
                      Container(
                          width: 1, height: 36, color: AppColors.border),
                      // Tren Naik — sinkron dengan Dashboard
                      _quickStat('$trendNaik', 'Tren Naik'),
                      Container(
                          width: 1, height: 36, color: AppColors.border),
                      // Omzet — sinkron dengan Dashboard (harga × terjual)
                      _quickStat(
                        Formatter.currency(totalRevenue),
                        'Omzet',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── INFORMASI DETAIL ──────────────────────────────────
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
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.textPrimary
                                .withValues(alpha: 0.05),
                            blurRadius: 8)
                      ],
                    ),
                    child: Text(_mgr.deskripsi,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.6)),
                  ),
                  const SizedBox(height: 20),

                  Text('Lainnya',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  _menuCard([
                    _menuItem(Icons.edit_outlined, 'Edit Profil',
                        _showEditProfile),
                    _menuItem(Icons.info_outline, 'Tentang Aplikasi',
                        _showAbout),
                  ]),
                  const SizedBox(height: 16),

                  // Tombol logout
                  GestureDetector(
                    onTap: _confirmLogout,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color:
                                AppColors.error.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout_rounded,
                                color: AppColors.error, size: 20),
                            const SizedBox(width: 10),
                            Text('Keluar Akun',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.error)),
                          ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text('Tanian Dashboard v1.0.0',
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editField(
    String label,
    TextEditingController ctrl, {
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary)),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl,
        keyboardType: inputType,
        maxLines: maxLines,
        style: GoogleFonts.inter(fontSize: 14),
        decoration: InputDecoration(
          hintText: label,
          prefixIcon:
              Icon(icon, color: AppColors.textSecondary, size: 20),
        ),
      ),
    ]);
  }

  Widget _quickStat(String value, String label) {
    return Column(children: [
      Text(value,
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      const SizedBox(height: 3),
      Text(label,
          style: GoogleFonts.inter(
              fontSize: 11, color: AppColors.textSecondary)),
    ]);
  }

  Widget _infoCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 8)
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return Column(children: [
            e.value,
            if (!isLast)
              const Divider(
                  height: 1, indent: 52, color: AppColors.border),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(value,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ]),
        ),
      ]),
    );
  }

  Widget _menuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 8)
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return Column(children: [
            e.value,
            if (!isLast)
              const Divider(
                  height: 1, indent: 52, color: AppColors.border),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary)),
          ),
          const Icon(Icons.chevron_right,
              color: AppColors.textSecondary, size: 18),
        ]),
      ),
    );
  }
}