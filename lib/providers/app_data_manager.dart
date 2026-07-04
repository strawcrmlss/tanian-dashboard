/// AppDataManager — Singleton untuk menyimpan data user dan profil UMKM.
/// Data diperoleh dari proses Register dan dapat diubah melalui Edit Profil.
class AppDataManager {
  AppDataManager._internal();
  static final AppDataManager instance = AppDataManager._internal();

  // ─── AUTH STATE ─────────────────────────────────────────────────────
  bool isLoggedIn = false;

  // ─── DATA USER (dari Register) ──────────────────────────────────────
  String name = '';
  String email = '';
  String phone = '';
  String address = '';
  String _password = '';

  // ─── PROFIL UMKM ────────────────────────────────────────────────────
  String namaUmkm = 'Tanian Agro';
  String deskripsi =
      'UMKM distributor hasil pertanian lokal Indonesia yang berkomitmen '
      'menghadirkan produk segar berkualitas langsung dari petani ke konsumen.';

  // ─── REGISTER ───────────────────────────────────────────────────────
  /// Menyimpan data dari form Register ke AppDataManager
  void register({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
  }) {
    this.name = name;
    this.email = email;
    this.phone = phone;
    this.address = address;
    _password = password;
    isLoggedIn = true;
  }

  // ─── LOGIN ───────────────────────────────────────────────────────────
  /// Validasi login — menerima email dan password apapun (dummy)
  bool login(String email, String password) {
    if (email.trim().isEmpty || password.length < 6) return false;
    // Jika sudah pernah register, isi dari data yang tersimpan
    if (this.email.isEmpty) {
      this.email = email;
      name = 'Pemilik UMKM';
      phone = '-';
      address = '-';
    }
    isLoggedIn = true;
    return true;
  }

  // ─── UPDATE PROFIL ───────────────────────────────────────────────────
  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? namaUmkm,
    String? deskripsi,
  }) {
    if (name != null && name.isNotEmpty) this.name = name;
    if (email != null && email.isNotEmpty) this.email = email;
    if (phone != null && phone.isNotEmpty) this.phone = phone;
    if (address != null && address.isNotEmpty) this.address = address;
    if (namaUmkm != null && namaUmkm.isNotEmpty) this.namaUmkm = namaUmkm;
    if (deskripsi != null && deskripsi.isNotEmpty) this.deskripsi = deskripsi;
  }

  // ─── LOGOUT ─────────────────────────────────────────────────────────
  void logout() {
    isLoggedIn = false;
  }
}