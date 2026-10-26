import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../state/app_state.dart';
import '../../widgets/app_svg_icon.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  // Form controllers
  final _loginEmailCtrl = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();

  final _registerNameCtrl = TextEditingController();
  final _registerEmailCtrl = TextEditingController();
  final _registerPhoneCtrl = TextEditingController();
  final _registerPasswordCtrl = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _registerNameCtrl.dispose();
    _registerEmailCtrl.dispose();
    _registerPhoneCtrl.dispose();
    _registerPasswordCtrl.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.accentRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _loginEmailCtrl.text.trim();
    final password = _loginPasswordCtrl.text;

    if (email.isEmpty) {
      _showErrorSnackBar('Harap masukkan alamat email.');
      return;
    }
    if (password.isEmpty) {
      _showErrorSnackBar('Harap masukkan kata sandi.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final credential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      if (credential.user != null && mounted) {
        _showSuccessSnackBar('Selamat datang kembali di VegBox!');
      }
    } catch (e) {
      _showErrorSnackBar(AuthService.getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRegister() async {
    final name = _registerNameCtrl.text.trim();
    final email = _registerEmailCtrl.text.trim();
    final phone = _registerPhoneCtrl.text.trim();
    final password = _registerPasswordCtrl.text;

    if (name.isEmpty) {
      _showErrorSnackBar('Harap masukkan nama lengkap Anda.');
      return;
    }
    if (email.isEmpty) {
      _showErrorSnackBar('Harap masukkan alamat email.');
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _showErrorSnackBar('Format email tidak valid.');
      return;
    }
    if (password.length < 6) {
      _showErrorSnackBar('Kata sandi minimal 6 karakter.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final credential = await _authService.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      );
      if (credential.user != null) {
        if (phone.isNotEmpty) {
          AppState().updateProfile(name: name, phone: phone, address: AppState().userAddress);
        }
        if (mounted) {
          _showSuccessSnackBar('Akun berhasil dibuat! Selamat bergabung.');
        }
      }
    } catch (e) {
      _showErrorSnackBar(AuthService.getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential?.user != null && mounted) {
        _showSuccessSnackBar('Berhasil masuk dengan akun Google!');
      }
    } catch (e) {
      _showErrorSnackBar(AuthService.getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _loginAsGuest() {
    AppState().loginAsGuest();
  }

  void _showForgotPasswordDialog(BuildContext context, bool isDark) {
    final resetEmailCtrl = TextEditingController(text: _loginEmailCtrl.text.trim());
    showDialog(
      context: context,
      builder: (ctx) {
        bool isSending = false;
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.cardDark : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text(
                'Lupa Kata Sandi?',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masukkan alamat email akun Anda. Kami akan mengirimkan tautan reset kata sandi.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: TextField(
                      controller: resetEmailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'nama@email.com',
                        prefixIcon: Icon(Icons.email_outlined, size: 18, color: AppColors.primaryMint),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSending ? null : () => Navigator.pop(ctx),
                  child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          final email = resetEmailCtrl.text.trim();
                          if (email.isEmpty) {
                            return;
                          }
                          setDialogState(() => isSending = true);
                          try {
                            await _authService.sendPasswordReset(email);
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                            }
                            if (mounted) {
                              _showSuccessSnackBar('Tautan reset kata sandi telah dikirim ke $email');
                            }
                          } catch (err) {
                            setDialogState(() => isSending = false);
                            _showErrorSnackBar(AuthService.getErrorMessage(err));
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isSending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Kirim Email', style: TextStyle(fontFamily: 'Poppins')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top Organic Header with Brand
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0F382A),
                    Color(0xFF1B4D3E),
                    Color(0xFF2D6A4F),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative background shapes
                  Positioned(
                    right: -10,
                    top: -10,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand Logo
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: const Icon(
                              Icons.eco_rounded,
                              color: AppColors.accentYellow,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'VegBox',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                'Fresh & Organic Harvest',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primaryMint,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Pilihan Sayur Segar\nLangsung Dari Petani.',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Main Auth Card Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Segmented Tabs [Masuk | Daftar]
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryLight.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                        ),
                        tabs: const [
                          Tab(text: 'Masuk'),
                          Tab(text: 'Daftar Akun'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tab View Content (Forms)
                    AnimatedBuilder(
                      animation: _tabController,
                      builder: (context, _) {
                        return _tabController.index == 0
                            ? _buildLoginForm(isDark)
                            : _buildRegisterForm(isDark);
                      },
                    ),

                    const SizedBox(height: 20),

                    // Social Login Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'atau masuk dengan',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.textMutedDark : Colors.grey,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Social Buttons Row
                    Row(
                      children: [
                        // Google Login
                        Expanded(
                          child: InkWell(
                            onTap: _isLoading ? null : _handleGoogleLogin,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppSvgIcon(
                                    assetName: 'assets/svg/google_logo.svg',
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Google',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Apple Login / Guest shortcut
                        Expanded(
                          child: InkWell(
                            onTap: _loginAsGuest,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppSvgIcon(
                                    assetName: 'assets/svg/apple_logo.svg',
                                    size: 20,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Apple',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Guest Login Option
                    TextButton(
                      onPressed: _isLoading ? null : _loginAsGuest,
                      child: const Text(
                        'Jelajahi Toko Sebagai Tamu →',
                        style: TextStyle(
                          color: AppColors.primaryMint,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Terms Footer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Dengan mendaftar, Anda menyetujui Ketentuan Layanan & Kebijakan Privasi VegBox Indonesia.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.textMutedDark : Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFieldLabel('Alamat Email', isDark),
        const SizedBox(height: 6),
        _buildInputField(
          controller: _loginEmailCtrl,
          hintText: 'nama@email.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          isDark: isDark,
        ),

        const SizedBox(height: 14),

        _buildTextFieldLabel('Kata Sandi', isDark),
        const SizedBox(height: 6),
        _buildInputField(
          controller: _loginPasswordCtrl,
          hintText: 'Masukkan kata sandi',
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          isDark: isDark,
        ),

        const SizedBox(height: 10),

        // Remember Me & Forgot Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    onChanged: (val) => setState(() => _rememberMe = val ?? true),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Ingat Saya',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => _showForgotPasswordDialog(context, isDark),
              child: const Text(
                'Lupa Sandi?',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primaryMint,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Login Action Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 4,
              shadowColor: AppColors.primary.withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text(
                    'Masuk Sekarang 🌿',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFieldLabel('Nama Lengkap', isDark),
        const SizedBox(height: 6),
        _buildInputField(
          controller: _registerNameCtrl,
          hintText: 'Cth: Dexter Morgan',
          icon: Icons.person_outline_rounded,
          isDark: isDark,
        ),

        const SizedBox(height: 12),

        _buildTextFieldLabel('Alamat Email', isDark),
        const SizedBox(height: 6),
        _buildInputField(
          controller: _registerEmailCtrl,
          hintText: 'nama@email.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          isDark: isDark,
        ),

        const SizedBox(height: 12),

        _buildTextFieldLabel('Nomor WhatsApp (Opsional)', isDark),
        const SizedBox(height: 6),
        _buildInputField(
          controller: _registerPhoneCtrl,
          hintText: 'Cth: 081234567890',
          icon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
          isDark: isDark,
        ),

        const SizedBox(height: 12),

        _buildTextFieldLabel('Buat Kata Sandi', isDark),
        const SizedBox(height: 6),
        _buildInputField(
          controller: _registerPasswordCtrl,
          hintText: 'Minimal 6 karakter',
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          isDark: isDark,
        ),

        const SizedBox(height: 18),

        // Register Action Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 4,
              shadowColor: AppColors.primaryLight.withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text(
                    'Daftar Akun Baru 🌾',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: isDark ? AppColors.textLight : AppColors.textDark,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 13,
          fontFamily: 'Poppins',
          color: isDark ? AppColors.textLight : AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins',
            color: isDark ? AppColors.textMutedDark : Colors.grey.shade400,
          ),
          prefixIcon: Icon(icon, size: 18, color: AppColors.primaryMint),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}
