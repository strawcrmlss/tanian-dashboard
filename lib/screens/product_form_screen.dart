import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product_item.dart';
import '../providers/product_provider.dart';
import '../utils/app_colors.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductItem? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _soldCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _category = 'Sayur';
  String _trend = 'up';
  bool _isLoading = false;

  // ── IMAGE STATE ─────────────────────────────────────────────────
  Uint8List? _imageBytes;
  bool _imageCleared = false;

  final ImagePicker _picker = ImagePicker();

  bool get _isEdit => widget.product != null;

  bool get _hasPreview {
    if (_imageBytes != null) return true;
    if (_imageCleared) return false;
    if (_isEdit) {
      return widget.product!.imageBytes != null ||
          (widget.product!.customImageUrl?.isNotEmpty ?? false);
    }
    return false;
  }

  static const List<String> _categories = [
    'Sayur', 'Buah', 'Rempah', 'Beras', 'Organik',
    'Telur', 'Cabai', 'Umbi', 'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final p = widget.product!;
      _nameCtrl.text = p.name;
      _priceCtrl.text = p.price.toString();
      _stockCtrl.text = p.stock.toString();
      _soldCtrl.text = p.sold.toString();
      _descCtrl.text = p.description;
      _category = _categories.contains(p.category) ? p.category : 'Lainnya';
      _trend = p.trend;
      _imageBytes = p.imageBytes;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _soldCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ── IMAGE PICKER ─────────────────────────────────────────────────
  Future<void> _pickImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (file == null) return;

      final bytes = await file.readAsBytes();

      // Validasi ukuran maks 5 MB
      if (bytes.lengthInBytes > 5 * 1024 * 1024) {
        if (mounted) {
          _showSnackBar(
            'Ukuran file terlalu besar. Maksimal 5 MB',
            isError: true,
          );
        }
        return;
      }

      if (mounted) {
        setState(() {
          _imageBytes = bytes;
          _imageCleared = false;
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal memilih foto: $e', isError: true);
      }
    }
  }

  void _clearImage() {
    setState(() {
      _imageBytes = null;
      _imageCleared = true;
    });
  }

  // ── SAVE ─────────────────────────────────────────────────────────
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    Uint8List? finalBytes;
    String? finalUrl;

    if (_imageBytes != null) {
      finalBytes = _imageBytes;
      finalUrl = null;
    } else if (_imageCleared) {
      finalBytes = null;
      finalUrl = null;
    } else if (_isEdit) {
      finalBytes = widget.product!.imageBytes;
      finalUrl = widget.product!.customImageUrl;
    }

    final product = ProductItem(
      id: _isEdit ? widget.product!.id : ProductProvider.instance.newId,
      name: _nameCtrl.text.trim(),
      category: _category,
      price: int.tryParse(_priceCtrl.text.trim()) ?? 0,
      stock: int.tryParse(_stockCtrl.text.trim()) ?? 0,
      sold: int.tryParse(_soldCtrl.text.trim()) ?? 0,
      trend: _trend,
      description: _descCtrl.text.trim(),
      imageBytes: finalBytes,
      customImageUrl: finalUrl,
    );

    if (_isEdit) {
      ProductProvider.instance.updateProduct(product);
    } else {
      ProductProvider.instance.addProduct(product);
    }

    setState(() => _isLoading = false);

    _showSnackBar(
      _isEdit
          ? '${product.name} berhasil diperbarui'
          : '${product.name} berhasil ditambahkan',
    );

    Navigator.pop(context, product);
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Produk' : 'Tambah Produk'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── FOTO PRODUK ────────────────────────────────────
                _buildLabel('Foto Produk'),
                const SizedBox(height: 10),
                _buildImageSection(),
                const SizedBox(height: 24),

                // ── NAMA ───────────────────────────────────────────
                _buildField(
                  label: 'Nama Produk',
                  ctrl: _nameCtrl,
                  hint: 'Contoh: Bayam Hijau Segar',
                  icon: Icons.inventory_2_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Nama produk wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // ── KATEGORI ───────────────────────────────────────
                _buildDropdown(
                  label: 'Kategori',
                  icon: Icons.category_outlined,
                  value: _category,
                  items: _categories,
                  onChanged: (v) => setState(() => _category = v!),
                ),
                const SizedBox(height: 18),

                // ── HARGA ──────────────────────────────────────────
                _buildField(
                  label: 'Harga (Rp)',
                  ctrl: _priceCtrl,
                  hint: 'Contoh: 15000',
                  icon: Icons.price_change_outlined,
                  inputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Harga wajib diisi';
                    }
                    if (int.tryParse(v.trim()) == null) {
                      return 'Harga harus angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // ── STOK & TERJUAL ─────────────────────────────────
                Row(children: [
                  Expanded(
                    child: _buildField(
                      label: 'Stok',
                      ctrl: _stockCtrl,
                      hint: '0',
                      icon: Icons.warehouse_outlined,
                      inputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Wajib diisi'
                              : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildField(
                      label: 'Terjual',
                      ctrl: _soldCtrl,
                      hint: '0',
                      icon: Icons.shopping_bag_outlined,
                      inputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Wajib diisi'
                              : null,
                    ),
                  ),
                ]),
                const SizedBox(height: 18),

                // ── TREN ───────────────────────────────────────────
                _buildTrendField(),
                const SizedBox(height: 18),

                // ── DESKRIPSI ──────────────────────────────────────
                _buildField(
                  label: 'Deskripsi (opsional)',
                  ctrl: _descCtrl,
                  hint: 'Deskripsi singkat produk...',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // ── TOMBOL SIMPAN ──────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.surface),
                            ),
                          )
                        : Text(
                            _isEdit
                                ? 'Simpan Perubahan'
                                : 'Tambah Produk',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── IMAGE SECTION ─────────────────────────────────────────────────
  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preview
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _hasPreview
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.border,
                width: 1.5,
              ),
            ),
            child: _buildPreview(),
          ),
        ),
        const SizedBox(height: 12),

        // Tombol aksi
        if (_hasPreview)
          Row(children: [
            Expanded(
              child: _imgBtn(
                emoji: '🔄',
                label: 'Ganti Foto',
                color: AppColors.primary,
                onTap: _pickImage,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _imgBtn(
                emoji: '🗑',
                label: 'Hapus Foto',
                color: AppColors.error,
                onTap: _clearImage,
              ),
            ),
          ])
        else
          _imgBtn(
            emoji: '📷',
            label: 'Upload Foto',
            color: AppColors.primary,
            onTap: _pickImage,
            fullWidth: true,
          ),
      ],
    );
  }

  Widget _buildPreview() {
    // Bytes baru dipilih
    if (_imageBytes != null) {
      return Image.memory(
        _imageBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 180,
      );
    }

    // Edit — tampilkan gambar lama jika belum dihapus
    if (_hasPreview && _isEdit) {
      final p = widget.product!;
      if (p.imageBytes != null) {
        return Image.memory(
          p.imageBytes!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 180,
        );
      }
      if (p.customImageUrl?.isNotEmpty ?? false) {
        return Image.network(
          p.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 180,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              color: AppColors.primaryLight.withValues(alpha: 0.2),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => _placeholder(),
        );
      }
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_outlined,
          size: 44,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 10),
        Text(
          'Belum ada foto produk',
          style: GoogleFonts.inter(
              fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          'Pilih gambar dari galeri — maks 5 MB',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.textSecondary.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _imgBtn({
    required String emoji,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── FORM HELPERS ─────────────────────────────────────────────────
  Widget _buildField({
    required String label,
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          style: GoogleFonts.inter(fontSize: 14),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
                fontSize: 14, color: AppColors.textSecondary),
            prefixIcon:
                Icon(icon, color: AppColors.textSecondary, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          style: GoogleFonts.inter(
              fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            prefixIcon:
                Icon(icon, color: AppColors.textSecondary, size: 20),
          ),
          items: items
              .map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c,
                      style: GoogleFonts.inter(fontSize: 14))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTrendField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Tren Penjualan'),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: _trendOption('up', 'Naik',
                Icons.trending_up_rounded, AppColors.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _trendOption('down', 'Turun',
                Icons.trending_down_rounded, AppColors.error),
          ),
        ]),
      ],
    );
  }

  Widget _trendOption(
      String value, String label, IconData icon, Color color) {
    final isSelected = _trend == value;
    return GestureDetector(
      onTap: () => setState(() => _trend = value),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? color : AppColors.textSecondary,
                size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    isSelected ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}