import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/product_provider.dart';
import '../models/product_item.dart';
import '../utils/app_colors.dart';
import '../utils/formatter.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/metric_card.dart';
import '../widgets/sales_list_item.dart';
import '../widgets/simple_bar_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<void> _future;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _future = ProductProvider.instance.loadProducts();
  }

  void _refresh() {
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
      body: Column(
        children: [
          DashboardHeader(onRefresh: _refresh, isLoading: _isRefreshing),
          Expanded(
            child: FutureBuilder<void>(
              future: _future,
              builder: (context, snapshot) {
                // ── LOADING STATE ────────────────────────────────────
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                            color: AppColors.primary, strokeWidth: 3),
                        SizedBox(height: 20),
                        Text('Memuat data dari server...',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 14)),
                        SizedBox(height: 6),
                        Text('Menghubungkan ke API Tanian',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  );
                }

                // ── ERROR STATE ──────────────────────────────────────
                if (ProductProvider.instance.hasError) {
                  return Center(
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
                            child: const Icon(Icons.wifi_off_rounded,
                                color: AppColors.error, size: 40),
                          ),
                          const SizedBox(height: 20),
                          Text('Gagal Memuat Data',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 8),
                          Text(
                            'Periksa koneksi internet, lalu coba muat ulang.',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 180,
                            height: 46,
                            child: ElevatedButton.icon(
                              onPressed: _refresh,
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Muat Ulang'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // ── SUCCESS STATE ────────────────────────────────────
                final products = ProductProvider.instance.products;
                return _buildDashboard(products);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(List<ProductItem> products) {
    final prov = ProductProvider.instance;
    final topSold = prov.sortedBySold.take(5).toList();
    final lowStockList = prov.lowStock.take(5).toList();
    final salesByCat = prov.salesByCategory;

    final chartData = (salesByCat.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .map((e) => SimpleBarChartData(
              label: e.key,
              value: e.value.toDouble(),
              color: AppColors.primary,
            ))
        .toList();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── RINGKASAN ANALISIS ──────────────────────────────
                _sectionTitle('Ringkasan Analisis', Icons.analytics_outlined),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isWide ? 5 : 2,
                  childAspectRatio: isWide ? 1 : 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    MetricCard(
                      icon: Icons.inventory_2_outlined,
                      label: 'Total Produk',
                      value: '${products.length} produk',
                      color: AppColors.primary,
                    ),
                    MetricCard(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Total Terjual',
                      value: '${prov.totalSold} unit',
                      color: AppColors.accent,
                      subtitle: 'Semua produk',
                    ),
                    MetricCard(
                      icon: Icons.payments_outlined,
                      label: 'Pendapatan',
                      value: Formatter.currency(prov.totalRevenue),
                      color: const Color(0xFF5C6BC0),
                      subtitle: 'Total omzet',
                    ),
                    MetricCard(
                      icon: Icons.trending_up_rounded,
                      label: 'Tren Naik',
                      value: '${prov.trendUpCount} produk',
                      color: AppColors.success,
                      subtitle: '↑ Performa baik',
                    ),
                    MetricCard(
                      icon: Icons.warning_amber_rounded,
                      label: 'Stok Menipis',
                      value: '${prov.lowStockCount} produk',
                      color: AppColors.error,
                      subtitle: '< 50 unit',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── KONTEN UTAMA ────────────────────────────────────
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: _buildTopSoldSection(topSold)),
                      const SizedBox(width: 16),
                      Expanded(
                          flex: 2,
                          child: _buildLowStockSection(lowStockList)),
                    ],
                  )
                else ...[
                  _buildTopSoldSection(topSold),
                  const SizedBox(height: 24),
                  _buildLowStockSection(lowStockList),
                ],
                const SizedBox(height: 24),

                // ── GRAFIK ──────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.textPrimary.withValues(alpha: 0.05),
                          blurRadius: 8)
                    ],
                  ),
                  child: SimpleBarChart(
                    title: 'Penjualan per Kategori',
                    data: chartData,
                    valueSuffix: ' unit',
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopSoldSection(List<ProductItem> topSold) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Produk Terlaris', Icons.star_outline_rounded),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topSold.length,
          itemBuilder: (_, i) =>
              SalesListItem(product: topSold[i], rank: i + 1),
        ),
      ],
    );
  }

  Widget _buildLowStockSection(List<ProductItem> lowStockList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Stok Menipis ⚠️', Icons.warning_amber_outlined),
        const SizedBox(height: 10),
        if (lowStockList.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              const Icon(Icons.check_circle_outline,
                  color: AppColors.success, size: 20),
              const SizedBox(width: 10),
              Text('Semua stok dalam kondisi aman',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.textSecondary)),
            ]),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: lowStockList.length,
              itemBuilder: (_, i) =>
                  _buildLowStockCard(lowStockList[i]),
            ),
          ),
      ],
    );
  }

  Widget _buildLowStockCard(ProductItem p) {
    return Container(
      width: 148,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 90,
              width: double.infinity,
              child: _buildLowStockImage(p),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  Formatter.currency(p.price),
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          size: 10, color: AppColors.error),
                      const SizedBox(width: 3),
                      Text(
                        'Stok: ${p.stock}',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockImage(ProductItem p) {
    if (p.hasLocalImage) {
      return Image.memory(p.imageBytes!, fit: BoxFit.cover);
    }
    return Image.network(
      p.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppColors.primaryLight.withValues(alpha: 0.15),
          child: const Center(
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.primary),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.primaryLight.withValues(alpha: 0.15),
        child: Center(
          child: Text(p.categoryEmoji, style: const TextStyle(fontSize: 32)),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.primary),
      const SizedBox(width: 8),
      Text(title,
          style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary)),
    ]);
  }
}