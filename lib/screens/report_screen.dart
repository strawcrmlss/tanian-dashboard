import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/product_provider.dart';
import '../models/product_item.dart';
import '../utils/app_colors.dart';
import '../utils/formatter.dart';
import '../widgets/simple_bar_chart.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<void> _future;
  bool _isRefreshing = false;

  // ── DUMMY AKTIVITAS TERBARU ──────────────────────────────────────
  final List<_ActivityItem> _activities = const [
    _ActivityItem(
      emoji: '🛒',
      title: 'Pesanan baru diterima',
      subtitle: 'Bayam Hijau Segar — 3 ikat',
      time: '15 menit lalu',
      color: AppColors.success,
    ),
    _ActivityItem(
      emoji: '💳',
      title: 'Pembayaran diterima',
      subtitle: 'Rp245.000',
      time: '20 menit lalu',
      color: AppColors.primary,
    ),
    _ActivityItem(
      emoji: '📦',
      title: 'Stok diperbarui',
      subtitle: 'Cabai Merah Keriting +50 kg',
      time: '1 jam lalu',
      color: AppColors.accent,
    ),
    _ActivityItem(
      emoji: '⚠️',
      title: 'Peringatan stok menipis',
      subtitle: 'Beras Pandan Wangi — sisa 12 unit',
      time: '2 jam lalu',
      color: AppColors.error,
    ),
    _ActivityItem(
      emoji: '✅',
      title: 'Produk baru ditambahkan',
      subtitle: 'Mangga Harum Manis',
      time: '3 jam lalu',
      color: AppColors.primary,
    ),
    _ActivityItem(
      emoji: '⭐',
      title: 'Produk terlaris hari ini',
      subtitle: 'Telur Ayam Kampung — 28 terjual',
      time: '5 jam lalu',
      color: AppColors.accent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _future = ProductProvider.instance.loadProducts();
  }

  Future<void> _refresh() async {
    setState(() {
      _isRefreshing = true;
      _future = ProductProvider.instance.refreshProducts().then((_) {
        if (mounted) setState(() => _isRefreshing = false);
      }).catchError((_) {
        if (mounted) setState(() => _isRefreshing = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Laporan'),
        actions: [
          _isRefreshing
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: AppColors.primary),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refresh,
                  tooltip: 'Refresh Data',
                ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _future,
        builder: (context, snapshot) {

          // ── LOADING STATE ──────────────────────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: AppColors.primary, strokeWidth: 3),
                  SizedBox(height: 20),
                  Text('Memuat laporan...',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 14)),
                  SizedBox(height: 6),
                  Text('Mengambil data dari server API',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            );
          }

          // ── ERROR STATE ────────────────────────────────────────────
          if (ProductProvider.instance.hasError || snapshot.hasError) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.cloud_off_rounded,
                                color: AppColors.error, size: 40),
                          ),
                          const SizedBox(height: 20),
                          Text('Gagal Memuat Laporan',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 8),
                          Text(
                            'Periksa koneksi internet Anda,\nlalu tarik ke bawah untuk mencoba lagi.',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tarik ke bawah untuk mencoba lagi',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.6)),
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: 180,
                            height: 46,
                            child: ElevatedButton.icon(
                              onPressed: _refresh,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                minimumSize: const Size(180, 46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.refresh, size: 18),
                              label: Text('Coba Lagi',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // ── SUCCESS STATE ──────────────────────────────────────────
          return _buildContent();
        },
      ),
    );
  }

  Widget _buildContent() {
    final prov = ProductProvider.instance;
    final products = prov.products;
    final topSold = prov.sortedBySold.take(5).toList();
    final lowStock = prov.lowStock.take(5).toList();
    final salesByCat = prov.salesByCategory;
    final countByCat = prov.countByCategory;

    final salesChartData = (salesByCat.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .map((e) => SimpleBarChartData(
              label: e.key,
              value: e.value.toDouble(),
              color: AppColors.primary,
            ))
        .toList();

    final countChartData = (countByCat.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .map((e) => SimpleBarChartData(
              label: e.key,
              value: e.value.toDouble(),
              color: const Color(0xFF5C6BC0),
            ))
        .toList();

    final trendChartData = [
      SimpleBarChartData(
        label: 'Tren Naik',
        value: prov.trendUpCount.toDouble(),
        color: AppColors.success,
      ),
      SimpleBarChartData(
        label: 'Tren Turun',
        value: prov.trendDownCount.toDouble(),
        color: AppColors.error,
      ),
    ];

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── A. RINGKASAN ANALISIS — COMPACT CARDS ───────────
                _sectionTitle('Ringkasan Analisis', Icons.analytics_outlined),
                const SizedBox(height: 10),
                // Menggunakan mainAxisExtent untuk tinggi card yang compact & konsisten
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 3 : 2,
                    mainAxisExtent: 88, // tinggi card compact
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 6,
                  itemBuilder: (_, index) {
                    final cards = [
                      _CompactStatCard(
                        icon: Icons.inventory_2_outlined,
                        label: 'Total Produk',
                        value: '${products.length} produk',
                        color: AppColors.primary,
                      ),
                      _CompactStatCard(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Total Penjualan',
                        value: '${prov.totalSold} unit',
                        color: AppColors.accent,
                      ),
                      _CompactStatCard(
                        icon: Icons.payments_outlined,
                        label: 'Pendapatan Bulan Ini',
                        value: Formatter.currency(prov.totalRevenue),
                        color: const Color(0xFF5C6BC0),
                      ),
                      _CompactStatCard(
                        icon: Icons.price_change_outlined,
                        label: 'Rata-rata Harga',
                        value: Formatter.currency(prov.avgPrice),
                        color: AppColors.success,
                      ),
                      _CompactStatCard(
                        icon: Icons.trending_up_rounded,
                        label: 'Produk Tren Naik',
                        value: '${prov.trendUpCount} produk',
                        color: AppColors.success,
                      ),
                      _CompactStatCard(
                        icon: Icons.trending_down_rounded,
                        label: 'Produk Tren Turun',
                        value: '${prov.trendDownCount} produk',
                        color: AppColors.error,
                      ),
                    ];
                    return cards[index];
                  },
                ),
                const SizedBox(height: 24),

                // ── AKTIVITAS TERBARU (DUMMY) ────────────────────────
                _sectionTitle('Aktivitas Terbaru', Icons.history_rounded),
                const SizedBox(height: 10),
                _buildActivityFeed(isWide),
                const SizedBox(height: 24),

                // ── B. DIAGRAM PENJUALAN PER KATEGORI ───────────────
                _sectionTitle(
                    'Diagram Penjualan per Kategori', Icons.bar_chart_rounded),
                const SizedBox(height: 10),
                _chartCard(salesChartData,
                    title: 'Penjualan per Kategori', suffix: ' unit'),
                const SizedBox(height: 16),
                _chartCard(countChartData,
                    title: 'Jumlah Produk per Kategori', suffix: ' produk'),
                const SizedBox(height: 16),
                _chartCard(trendChartData,
                    title: 'Distribusi Tren Produk', suffix: ' produk'),
                const SizedBox(height: 24),

                // ── C. TOP 5 PRODUK TERLARIS ─────────────────────────
                _sectionTitle('Top 5 Produk Terlaris', Icons.star_rounded),
                const SizedBox(height: 10),
                _buildRankedProductList(topSold,
                    valueBuilder: (p) => '${p.sold} terjual',
                    valueColor: AppColors.accent),
                const SizedBox(height: 24),

                // ── D. PRODUK STOK MENIPIS ───────────────────────────
                _sectionTitle(
                    'Produk Stok Menipis', Icons.warning_amber_rounded),
                const SizedBox(height: 10),
                lowStock.isEmpty
                    ? _emptyCard('Semua stok dalam kondisi aman',
                        Icons.check_circle_outline, AppColors.success)
                    : _buildRankedProductList(lowStock,
                        valueBuilder: (p) => 'Sisa: ${p.stock}',
                        valueColor: AppColors.error,
                        showRank: false),
                const SizedBox(height: 24),

                // ── E. RINGKASAN PERFORMA UMKM ───────────────────────
                _sectionTitle(
                    'Ringkasan Performa UMKM', Icons.emoji_events_outlined),
                const SizedBox(height: 10),
                _buildPerformaSummary(prov),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── AKTIVITAS TERBARU ─────────────────────────────────────────────
  Widget _buildActivityFeed(bool isWide) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 8),
        ],
      ),
      child: Column(
        children: _activities.asMap().entries.map((e) {
          final idx = e.key;
          final activity = e.value;
          final isLast = idx == _activities.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Icon bubble
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: activity.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: activity.color.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Center(
                        child: Text(activity.emoji,
                            style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activity.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Waktu
                    Text(
                      activity.time,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.textSecondary
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                    height: 1, indent: 70, color: AppColors.border),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── RANKED PRODUCT LIST (dengan foto) ────────────────────────────
  Widget _buildRankedProductList(
    List<ProductItem> items, {
    required String Function(ProductItem) valueBuilder,
    required Color valueColor,
    bool showRank = true,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final p = items[i];
        final isTop3 = i < 3 && showRank;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.05),
                  blurRadius: 8)
            ],
          ),
          child: Row(children: [
            if (showRank)
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: isTop3
                      ? AppColors.accent.withValues(alpha: 0.2)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: isTop3
                      ? Border.all(
                          color: AppColors.accent.withValues(alpha: 0.5))
                      : null,
                ),
                child: Center(
                  child: Text('#${i + 1}',
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isTop3
                              ? AppColors.accent
                              : AppColors.textSecondary)),
                ),
              ),

            // Foto produk
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 52,
                height: 52,
                child: p.hasLocalImage
                    ? Image.memory(p.imageBytes!, fit: BoxFit.cover)
                    : Image.network(
                        p.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: AppColors.primaryLight
                                .withValues(alpha: 0.15),
                            child: const Center(
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.primaryLight
                              .withValues(alpha: 0.15),
                          child: Center(
                            child: Text(p.categoryEmoji,
                                style: const TextStyle(fontSize: 22)),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(p.category,
                          style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark)),
                    ),
                  ]),
            ),

            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(valueBuilder(p),
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: valueColor)),
              const SizedBox(height: 2),
              Text(Formatter.currency(p.price),
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textSecondary)),
            ]),
          ]),
        );
      },
    );
  }

  // ── RINGKASAN PERFORMA UMKM ──────────────────────────────────────
  Widget _buildPerformaSummary(ProductProvider prov) {
    final items = [
      _PerformaItem(
        icon: Icons.star_rounded,
        color: AppColors.accent,
        label: 'Produk Paling Laris',
        value: prov.products.isEmpty ? '-' : prov.mostPopularProduct,
      ),
      _PerformaItem(
        icon: Icons.category_rounded,
        color: AppColors.primary,
        label: 'Kategori Paling Diminati',
        value: prov.topCategory,
      ),
      _PerformaItem(
        icon: Icons.payments_outlined,
        color: const Color(0xFF5C6BC0),
        label: 'Total Omzet Bulan Ini',
        value: Formatter.currency(prov.totalRevenue),
      ),
      _PerformaItem(
        icon: Icons.trending_up_rounded,
        color: AppColors.success,
        label: 'Produk Tren Naik',
        value: '${prov.trendUpPercentage.toStringAsFixed(0)}%',
      ),
      _PerformaItem(
        icon: Icons.inventory_2_outlined,
        color: AppColors.primary,
        label: 'Persentase Stok Aman',
        value: '${prov.safeStockPercentage.toStringAsFixed(0)}%',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 8),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final idx = e.key;
          final item = e.value;
          final isLast = idx == items.length - 1;
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.label,
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(height: 2),
                      Text(item.value,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ]),
            ),
            if (!isLast)
              const Divider(height: 1, indent: 70, color: AppColors.border),
          ]);
        }).toList(),
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────────
  Widget _chartCard(List<SimpleBarChartData> data,
      {required String title, String suffix = ''}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 8),
        ],
      ),
      child: SimpleBarChart(title: title, data: data, valueSuffix: suffix),
    );
  }

  Widget _emptyCard(String message, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Text(message,
            style: GoogleFonts.inter(
                fontSize: 13, color: AppColors.textSecondary)),
      ]),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.primary),
      const SizedBox(width: 8),
      Expanded(
        child: Text(title,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      ),
    ]);
  }
}

// ── COMPACT STAT CARD (horizontal layout, tinggi 88px) ─────────────
class _CompactStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _CompactStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          // Icon compact
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),

          // Value + label (vertical, kanan ikon)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── DATA CLASSES ─────────────────────────────────────────────────────
class _ActivityItem {
  final String emoji;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });
}

class _PerformaItem {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _PerformaItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });
}