import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../state/app_state.dart';
import '../widgets/app_svg_icon.dart';
import 'home/home_screen.dart';
import 'category/category_screen.dart';
import 'cart/cart_screen.dart';
import 'orders/orders_screen.dart';
import 'profile/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  late PageController _pageController;
  final AppState _appState = AppState();

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _appState.currentNavIndex);
    _appState.addListener(_handleAppStateChange);
  }

  void _handleAppStateChange() {
    if (_pageController.hasClients &&
        _pageController.page?.round() != _appState.currentNavIndex) {
      _pageController.animateToPage(
        _appState.currentNavIndex,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _appState.removeListener(_handleAppStateChange);
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_appState.currentNavIndex != index) {
      _appState.setNavIndex(index);
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _appState,
      builder: (context, _) {
        final currentIndex = _appState.currentNavIndex;

        return Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // prevents conflict with nested horizontal lists
            children: _screens,
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.5)
                        : AppColors.primary.withOpacity(0.08),
                    blurRadius: 26,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Tab 0: Home
                  _AnimatedNavButton(
                    index: 0,
                    currentIndex: currentIndex,
                    svgPath: 'assets/svg/home.svg',
                    label: 'Beranda',
                    onTap: () => _onTabTapped(0),
                  ),

                  // Tab 1: Category
                  _AnimatedNavButton(
                    index: 1,
                    currentIndex: currentIndex,
                    svgPath: 'assets/svg/category.svg',
                    label: 'Kategori',
                    onTap: () => _onTabTapped(1),
                  ),

                  // Tab 2: Cart (Highlighted Center Action)
                  _AnimatedCenterCartButton(
                    index: 2,
                    currentIndex: currentIndex,
                    badgeCount: _appState.cartCount,
                    onTap: () => _onTabTapped(2),
                  ),

                  // Tab 3: Orders
                  _AnimatedNavButton(
                    index: 3,
                    currentIndex: currentIndex,
                    svgPath: 'assets/svg/document.svg',
                    label: 'Pesanan',
                    onTap: () => _onTabTapped(3),
                  ),

                  // Tab 4: Profile
                  _AnimatedNavButton(
                    index: 4,
                    currentIndex: currentIndex,
                    svgPath: 'assets/svg/profile.svg',
                    label: 'Profil',
                    onTap: () => _onTabTapped(4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedNavButton extends StatefulWidget {
  final int index;
  final int currentIndex;
  final String svgPath;
  final String label;
  final VoidCallback onTap;

  const _AnimatedNavButton({
    required this.index,
    required this.currentIndex,
    required this.svgPath,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedNavButton> createState() => _AnimatedNavButtonState();
}

class _AnimatedNavButtonState extends State<_AnimatedNavButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.index == widget.currentIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.90 : (_isHovered ? 1.08 : 1.0),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryMint.withOpacity(isDark ? 0.22 : 0.15)
                  : (_isHovered
                      ? (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03))
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  child: AppSvgIcon(
                    assetName: widget.svgPath,
                    size: 20,
                    color: isSelected
                        ? AppColors.primaryLight
                        : (isDark ? AppColors.textMutedDark : Colors.grey),
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: isSelected
                        ? AppColors.primaryLight
                        : (isDark ? AppColors.textMutedDark : Colors.grey),
                  ),
                  child: Text(widget.label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedCenterCartButton extends StatefulWidget {
  final int index;
  final int currentIndex;
  final int badgeCount;
  final VoidCallback onTap;

  const _AnimatedCenterCartButton({
    required this.index,
    required this.currentIndex,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  State<_AnimatedCenterCartButton> createState() => _AnimatedCenterCartButtonState();
}

class _AnimatedCenterCartButtonState extends State<_AnimatedCenterCartButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.index == widget.currentIndex;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.90 : (_isHovered ? 1.12 : 1.0),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSelected
                    ? [AppColors.accentOrange, const Color(0xFFE85D04)]
                    : [AppColors.primaryLight, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: (isSelected ? AppColors.accentOrange : AppColors.primary)
                      .withOpacity(_isHovered ? 0.5 : 0.35),
                  blurRadius: _isHovered ? 16 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const AppSvgIcon(
                  assetName: 'assets/svg/basket.svg',
                  size: 22,
                  color: Colors.white,
                ),
                if (widget.badgeCount > 0)
                  Positioned(
                    top: -8,
                    right: -8,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.accentYellow,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            widget.badgeCount > 9 ? '9+' : '${widget.badgeCount}',
                            style: const TextStyle(
                              color: Color(0xFF332000),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
