import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../state/app_state.dart';
import '../../widgets/app_svg_icon.dart';
import '../../widgets/vegetable_image.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  String _formatCurrency(double amount) {
    final int intAmount = amount.toInt();
    return 'Rp ${intAmount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _showCheckoutSuccess(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryMint.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primaryMint,
                  size: 56,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Pesanan Berhasil Dibuat! 🎉',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Petani kami sedang menyiapkan sayuran segar terbaik Anda. Kurir akan segera meluncur ke lokasi!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                  fontFamily: 'Poppins',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    appState.clearCart();
                    Navigator.pop(ctx);
                    appState.setNavIndex(3); // Navigate to orders tab
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Lihat Status Pesanan 🛵',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
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
        final cartItems = appState.cart;

        return Scaffold(
          backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            elevation: 0,
            title: Row(
              children: [
                Text(
                  'Keranjang Segar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMint.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${appState.cartCount}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryLight,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              if (cartItems.isNotEmpty)
                TextButton(
                  onPressed: () => appState.clearCart(),
                  child: const Text(
                    'Kosongkan',
                    style: TextStyle(
                      color: AppColors.accentRed,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          body: cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft.withOpacity(isDark ? 0.08 : 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const AppSvgIcon(
                          assetName: 'assets/svg/basket.svg',
                          size: 60,
                          color: AppColors.primaryMint,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Keranjang Anda Masih Kosong',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: isDark ? AppColors.textLight : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pilih sayuran segar favorit Anda hari ini!',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => appState.setNavIndex(0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Mulai Belanja Sayur 🥕',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Free Shipping Notice Banner
                    if (appState.subtotal < 50000)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.accentYellow.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_shipping_outlined,
                              size: 18,
                              color: AppColors.accentOrange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Tambah ${_formatCurrency(50000 - appState.subtotal)} lagi untuk Bebas Ongkir!',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentOrange,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryMint.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primaryMint.withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 18,
                              color: AppColors.primaryLight,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Selamat! Anda mendapatkan Bebas Ongkir 🎉',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryLight,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Items List
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: cartItems.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final veg = item.vegetable;

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.cardDark : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Thumbnail
                                Container(
                                  width: 65,
                                  height: 65,
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySoft.withOpacity(isDark ? 0.08 : 0.4),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: VegetableImage(
                                    imagePath: veg.imagePath,
                                    fit: BoxFit.contain,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        veg.name,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Poppins',
                                          color: isDark ? AppColors.textLight : AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${_formatCurrency(veg.price)} / ${veg.unit}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatCurrency(item.totalPrice),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryMint,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Stepper (- / +)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () => appState.decreaseQuantity(veg.id),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            item.quantity == 1 ? Icons.delete_outline_rounded : Icons.remove,
                                            size: 16,
                                            color: item.quantity == 1 ? Colors.redAccent : AppColors.primaryLight,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          '${item.quantity}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            color: isDark ? AppColors.textLight : AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => appState.addToCart(veg),
                                        borderRadius: BorderRadius.circular(8),
                                        child: const Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.add,
                                            size: 16,
                                            color: AppColors.primaryLight,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Voucher & Summary Checkout Panel
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, -6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Promo Input
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _promoController,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      color: isDark ? AppColors.textLight : AppColors.textDark,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: appState.appliedPromoCode.isNotEmpty
                                          ? 'Voucher: ${appState.appliedPromoCode}'
                                          : 'Gunakan Voucher (cth: VEG75)',
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        color: isDark ? AppColors.textMutedDark : Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (appState.appliedPromoCode.isEmpty)
                                ElevatedButton(
                                  onPressed: () {
                                    final success = appState.applyPromoCode(_promoController.text);
                                    if (!success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Voucher tidak valid. Coba VEG75'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryLight,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  child: const Text('Pakai', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                                )
                              else
                                TextButton(
                                  onPressed: () {
                                    appState.removePromoCode();
                                    _promoController.clear();
                                  },
                                  child: const Text(
                                    'Hapus',
                                    style: TextStyle(color: Colors.redAccent, fontSize: 12, fontFamily: 'Poppins'),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Summary Breakdown
                          _buildSummaryRow(
                            'Subtotal',
                            _formatCurrency(appState.subtotal),
                            isDark: isDark,
                          ),
                          const SizedBox(height: 6),
                          _buildSummaryRow(
                            'Biaya Pengiriman',
                            appState.deliveryFee == 0 ? 'GRATIS' : _formatCurrency(appState.deliveryFee),
                            isDark: isDark,
                            valueColor: appState.deliveryFee == 0 ? AppColors.primaryMint : null,
                          ),
                          if (appState.promoDiscount > 0) ...[
                            const SizedBox(height: 6),
                            _buildSummaryRow(
                              'Diskon Voucher',
                              '- ${_formatCurrency(appState.promoDiscount)}',
                              isDark: isDark,
                              valueColor: AppColors.accentOrange,
                            ),
                          ],

                          const Divider(height: 20),

                          // Grand Total & Checkout CTA
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Pembayaran',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    _formatCurrency(appState.grandTotal),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      color: AppColors.primaryMint,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _showCheckoutSuccess(context, appState),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    shadowColor: AppColors.primary.withOpacity(0.4),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: const Text(
                                    'Pesan Sekarang 🛵',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, {required bool isDark, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins',
            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: valueColor ?? (isDark ? AppColors.textLight : AppColors.textDark),
          ),
        ),
      ],
    );
  }
}
