import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../state/app_state.dart';
import '../../widgets/app_svg_icon.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, AppState appState) {
    final nameCtrl = TextEditingController(text: appState.userName);
    final phoneCtrl = TextEditingController(text: appState.userPhone);
    final addressCtrl = TextEditingController(text: appState.userAddress);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Edit Profil Pengguna',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _buildModalTextField('Nama Lengkap', nameCtrl, isDark),
                const SizedBox(height: 12),
                _buildModalTextField('Nomor WhatsApp', phoneCtrl, isDark),
                const SizedBox(height: 12),
                _buildModalTextField('Alamat Pengiriman', addressCtrl, isDark, maxLines: 2),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      appState.updateProfile(
                        name: nameCtrl.text,
                        phone: phoneCtrl.text,
                        address: addressCtrl.text,
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profil berhasil diperbarui!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Simpan Perubahan', style: TextStyle(fontFamily: 'Poppins')),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalTextField(String label, TextEditingController ctrl, bool isDark, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: TextField(
            controller: ctrl,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Poppins',
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Text('Konfirmasi Keluar', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun VegBox Anda?',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                appState.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Keluar', style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = AppState();

    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            elevation: 0,
            title: Text(
              'Profil Pengguna',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            child: Column(
              children: [
                // Profile Avatar & Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Avatar with leafy organic badge
                          Stack(
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [AppColors.primaryLight, AppColors.primaryMint],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryMint.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: appState.userPhotoUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(34),
                                        child: Image.network(
                                          appState.userPhotoUrl!,
                                          width: 68,
                                          height: 68,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Center(
                                            child: Text(
                                              appState.userName.isNotEmpty
                                                  ? appState.userName.substring(0, 1).toUpperCase()
                                                  : 'V',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          appState.userName.isNotEmpty
                                              ? appState.userName.substring(0, 1).toUpperCase()
                                              : 'V',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.accentYellow,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.eco_rounded,
                                    size: 12,
                                    color: Color(0xFF332000),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),

                          // Name & Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appState.userName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                    color: isDark ? AppColors.textLight : AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  appState.userEmail,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryMint.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    '🌿 Member Organik VIP',
                                    style: TextStyle(
                                      color: AppColors.primaryLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Edit Icon
                          IconButton(
                            onPressed: () => _showEditProfileDialog(context, appState),
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            color: AppColors.primaryMint,
                          ),
                        ],
                      ),

                      const Divider(height: 28),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProfileStat('14', 'Pesanan', isDark),
                          Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.2)),
                          _buildProfileStat('1.450', 'Poin Panen', isDark, color: AppColors.accentOrange),
                          Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.2)),
                          _buildProfileStat('3', 'Voucher', isDark, color: AppColors.primaryMint),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Theme Mode Switcher Card (Using sun.svg & moon.svg assets)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : AppColors.primarySoft.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: AppSvgIcon(
                              assetName: isDark ? 'assets/svg/moon.svg' : 'assets/svg/sun.svg',
                              size: 20,
                              color: isDark ? AppColors.accentYellow : AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mode Tampilan',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: isDark ? AppColors.textLight : AppColors.textDark,
                                ),
                              ),
                              Text(
                                isDark ? 'Mode Gelap Aktif' : 'Mode Terang Aktif',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: isDark,
                        activeTrackColor: AppColors.primaryMint,
                        onChanged: (_) => appState.toggleTheme(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Settings Menu Group
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Alamat Pengiriman',
                        subtitle: appState.userAddress,
                        onTap: () => _showEditProfileDialog(context, appState),
                        isDark: isDark,
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Metode Pembayaran',
                        subtitle: 'GoPay, OVO, Bank Transfer, COD',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Metode pembayaran utama: GoPay (Terhubung)')),
                          );
                        },
                        isDark: isDark,
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.discount_outlined,
                        title: 'Voucher & Kupon Saya',
                        subtitle: 'Gunakan kode: VEG75 untuk diskon 20%',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Voucher aktif: VEG75')),
                          );
                        },
                        isDark: isDark,
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.help_outline_rounded,
                        title: 'Bantuan & Layanan CS',
                        subtitle: 'Hubungi via WhatsApp 24/7',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Menghubungkan ke Customer Support VegBox...')),
                          );
                        },
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Logout Button
                InkWell(
                  onTap: () => _showLogoutDialog(context, appState),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accentRed.withOpacity(0.2),
                      ),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.logout_rounded, color: AppColors.accentRed, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Keluar dari Akun',
                            style: TextStyle(
                              color: AppColors.accentRed,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileStat(String value, String label, bool isDark, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: color ?? (isDark ? AppColors.textLight : AppColors.textDark),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primarySoft.withOpacity(isDark ? 0.08 : 0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: AppColors.primaryLight),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: isDark ? AppColors.textLight : AppColors.textDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          fontFamily: 'Poppins',
          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 64, endIndent: 20, color: Colors.grey.withOpacity(0.12));
  }
}
