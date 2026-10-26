import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/vegetable_model.dart';
import '../state/app_state.dart';
import '../screens/detail/product_detail_screen.dart';
import 'vegetable_image.dart';

class VegetableCard extends StatefulWidget {
  final VegetableModel vegetable;
  final VoidCallback? onAddToCart;

  const VegetableCard({
    super.key,
    required this.vegetable,
    this.onAddToCart,
  });

  @override
  State<VegetableCard> createState() => _VegetableCardState();
}

class _VegetableCardState extends State<VegetableCard> {
  bool _isHovered = false;
  bool _isAddPressed = false;

  String _formatCurrency(double amount) {
    final int intAmount = amount.toInt();
    return 'Rp ${intAmount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = AppState();
    final veg = widget.vegetable;

    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final isFav = appState.isFavorite(veg.id);

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ProductDetailScreen(vegetable: veg),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.04, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
            child: AnimatedScale(
              scale: _isHovered ? 1.03 : 1.0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isHovered
                        ? AppColors.primaryMint.withOpacity(0.6)
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: _isHovered ? 1.8 : 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(_isHovered ? 0.5 : 0.28)
                          : AppColors.primary.withOpacity(_isHovered ? 0.12 : 0.05),
                      blurRadius: _isHovered ? 24 : 16,
                      offset: _isHovered ? const Offset(0, 10) : const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Discount / Organic Badge & Favorite Heart
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (veg.hasDiscount)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.accentOrange, AppColors.accentYellow],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '-${veg.discountPercentage}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryMint.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'ORGANIK',
                                style: TextStyle(
                                  color: AppColors.primaryLight,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          // Favorite Icon Button with smooth bounce
                          GestureDetector(
                            onTap: () => appState.toggleFavorite(veg.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isFav
                                    ? Colors.red.withOpacity(0.12)
                                    : (isDark
                                        ? Colors.white.withOpacity(0.06)
                                        : Colors.black.withOpacity(0.04)),
                                shape: BoxShape.circle,
                              ),
                              child: AnimatedScale(
                                scale: isFav ? 1.15 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.elasticOut,
                                child: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  size: 17,
                                  color: isFav ? Colors.redAccent : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Image Container with fade-in and graceful errorBuilder
                      Expanded(
                        child: Center(
                          child: Hero(
                            tag: 'veg_img_${veg.id}',
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryMint.withOpacity(_isHovered ? 0.22 : 0.10),
                                    blurRadius: _isHovered ? 26 : 18,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: VegetableImage(
                                imagePath: veg.imagePath,
                                fit: BoxFit.contain,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Rating & Reviews row
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: AppColors.accentYellow,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${veg.rating}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: isDark ? AppColors.textLight : AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${veg.reviewsCount})',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 3),

                      // Name
                      Text(
                        veg.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: isDark ? AppColors.textLight : AppColors.textDark,
                        ),
                      ),

                      // Unit
                      Text(
                        veg.unit,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Price and Add-To-Cart button row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (veg.hasDiscount)
                                  Text(
                                    _formatCurrency(veg.originalPrice!),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                Text(
                                  _formatCurrency(veg.price),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryMint,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Modern rounded add button with smooth press & hover animation
                          GestureDetector(
                            onTapDown: (_) => setState(() => _isAddPressed = true),
                            onTapUp: (_) {
                              setState(() => _isAddPressed = false);
                              appState.addToCart(veg);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${veg.name} masuk keranjang',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: AppColors.primaryLight,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  duration: const Duration(milliseconds: 1400),
                                ),
                              );
                              widget.onAddToCart?.call();
                            },
                            onTapCancel: () => setState(() => _isAddPressed = false),
                            child: AnimatedScale(
                              scale: _isAddPressed ? 0.86 : (_isHovered ? 1.08 : 1.0),
                              duration: const Duration(milliseconds: 160),
                              curve: Curves.easeOutBack,
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.primaryLight,
                                      AppColors.primary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
