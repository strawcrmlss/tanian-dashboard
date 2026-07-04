import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_data_manager.dart';
import '../../utils/app_colors.dart';
import '../main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    // Simpan data ke AppDataManager — otomatis muncul di halaman Profil
    AppDataManager.instance.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      password: _passCtrl.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Akun berhasil dibuat! Selamat datang.'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    setState(() => _isLoading = false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Buat Akun'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daftar Akun Baru',
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('Lengkapi data diri dan usaha Anda',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 28),

                // Nama Lengkap
                _buildField(
                  label: 'Nama Lengkap',
                  ctrl: _nameCtrl,
                  hint: 'Masukkan nama lengkap',
                  icon: Icons.person_outline,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    if (v.trim().length < 3) return 'Nama minimal 3 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Email
                _buildField(
                  label: 'Email',
                  ctrl: _emailCtrl,
                  hint: 'Masukkan email aktif',
                  icon: Icons.email_outlined,
                  inputType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!v.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Nomor HP
                _buildField(
                  label: 'Nomor HP',
                  ctrl: _phoneCtrl,
                  hint: 'Contoh: 081234567890',
                  icon: Icons.phone_outlined,
                  inputType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Nomor HP tidak boleh kosong';
                    }
                    if (!RegExp(r'^08[0-9]{8,11}$').hasMatch(v.trim())) {
                      return 'Format nomor HP tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Alamat Lengkap
                _buildField(
                  label: 'Alamat Lengkap',
                  ctrl: _addressCtrl,
                  hint: 'Jalan, nomor, RT/RW, kelurahan, kota',
                  icon: Icons.location_on_outlined,
                  maxLines: 3,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    if (v.trim().length < 10) {
                      return 'Alamat terlalu singkat';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Password
                _buildLabel('Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Minimal 6 karakter',
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: AppColors.textSecondary, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (v.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Konfirmasi Password
                _buildLabel('Konfirmasi Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPassCtrl,
                  obscureText: _obscureConfirm,
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Ulangi password',
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: AppColors.textSecondary, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    if (v != _passCtrl.text) return 'Password tidak sama';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Tombol daftar
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
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
                      : const Text('Daftar Sekarang'),
                ),
                const SizedBox(height: 16),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Sudah punya akun? ',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: AppColors.textSecondary)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Masuk',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                  ),
                ]),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildLabel(label),
      const SizedBox(height: 8),
      TextFormField(
        controller: ctrl,
        keyboardType: inputType,
        maxLines: maxLines,
        style: GoogleFonts.inter(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        ),
        validator: validator,
      ),
    ]);
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