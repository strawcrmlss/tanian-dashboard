import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Lupa Password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _emailSent ? _buildSuccess() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.lock_reset_outlined,
                size: 34, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text('Reset Password',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(
            'Masukkan email yang terdaftar. Kami akan mengirimkan link untuk mereset password Anda.',
            style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 32),
          Text('Email',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.inter(fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Masukkan email terdaftar',
              prefixIcon: Icon(Icons.email_outlined,
                  color: AppColors.textSecondary, size: 20),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Email tidak boleh kosong';
              }
              if (!v.contains('@')) return 'Format email tidak valid';
              return null;
            },
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _isLoading ? null : _sendReset,
            child: _isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.surface),
                    ),
                  )
                : const Text('Kirim Link Reset'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mark_email_read_outlined,
                size: 46, color: AppColors.success),
          ),
          const SizedBox(height: 24),
          Text('Email Terkirim!',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Text(
            'Link reset password telah dikirim ke\n${_emailCtrl.text}\n\nSilakan periksa inbox email Anda.',
            style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.textSecondary, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali ke Login'),
          ),
        ],
      ),
    );
  }
}