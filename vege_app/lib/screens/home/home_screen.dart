import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../state/app_state.dart';
import '../../widgets/app_svg_icon.dart';
import '../../widgets/vegetable_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = AppState();

    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final categoryList = [
          'Semua',
          if (appState.categories.isNotEmpty)
            ...appState.categories.map((c) => c.nama)
          else ...[
            'Sayuran Daun',
            'Sayuran Buah',
            'Sayuran Umbi',
            'Sayuran Polong',
          ]
        ];

        // Filter vegetables based on category and search query
        final filteredVegs = appState.vegetables.where((v) {
          final matchesCategory = appState.selectedCategory == 'Semua' ||
              (appState.selectedCategory == 'Organik' && v.isOrganic) ||
              v.category.toLowerCase() == appState.selectedCategory.toLowerCase();

          final matchesSearch = appState.searchQuery.isEmpty ||
              v.name.toLowerCase().contains(appState.searchQuery.toLowerCase()) ||
              v.category.toLowerCase().contains(appState.searchQuery.toLowerCase());

          return matchesCategory && matchesSearch;
        }).toList();

        return Scaffold(
          backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColors.primaryMint,
              onRefresh: () async {
                await appState.fetchVegetables(refresh: true);
                await appState.fetchCategories();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                // Top Custom App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Location and Greeting
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryMint.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.location_on_rounded,
                                      size: 16,
                                      color: AppColors.primaryMint,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Alamat Pengiriman',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Rumah Dexter (Kebayoran Baru)',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                        color: isDark ? AppColors.textLight : AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Action Buttons: Theme Toggle & Notification
                        Row(
                          children: [
                            // Theme toggle using user's sun & moon svg
                            InkWell(
                              onTap: () => appState.toggleTheme(),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.cardDark : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: AppSvgIcon(
                                  assetName: isDark ? 'assets/svg/sun.svg' : 'assets/svg/moon.svg',
                                  size: 20,
                                  color: isDark ? AppColors.accentYellow : AppColors.primary,
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Notification bell
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.cardDark : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.notifications_none_rounded,
                                    size: 20,
                                    color: isDark ? AppColors.textLight : AppColors.textDark,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.accentOrange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => appState.setSearchQuery(val),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: isDark ? AppColors.textLight : AppColors.textDark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari wortel, tomat, bawang segar...',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: isDark ? AppColors.textMutedDark : Colors.grey.shade400,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: AppSvgIcon(
                              assetName: 'assets/svg/search.svg',
                              size: 18,
                              color: AppColors.primaryMint,
                            ),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    appState.setSearchQuery('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ),

                // Hero Promo Banner (Neo-Organic Fresh Harvest)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0F382A),
                          Color(0xFF1B5E45),
                          Color(0xFF2D8A65),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1B5E45).withOpacity(0.35),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Background decorative circle glow
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryMint.withOpacity(0.2),
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Harvest Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentYellow,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'PROMO PANEN RAYA 🌾',
                                      style: TextStyle(
                                        color: Color(0xFF332000),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Diskon s/d 75%\nSayuran Petani Lokal',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.3),
                                          ),
                                        ),
                                        child: const Text(
                                          'KODE: VEG75',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.8,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Floating preview vegetable
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 110,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      right: 0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          'assets/images/pepper.png',
                                          height: 90,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.eco_rounded,
                                            size: 60,
                                            color: AppColors.primaryMint,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          'assets/images/carrot.png',
                                          height: 80,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.eco_rounded,
                                            size: 50,
                                            color: AppColors.accentOrange,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Category Chips List
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kategori Segar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                color: isDark ? AppColors.textLight : AppColors.textDark,
                              ),
                            ),
                            Text(
                              '${filteredVegs.length} item',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryMint,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: categoryList.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final cat = categoryList[index];
                            final isSelected = appState.selectedCategory == cat;

                            return _HoverableCategoryChip(
                              label: cat,
                              isSelected: isSelected,
                              isDark: isDark,
                              onTap: () => appState.setCategory(cat),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),

                // Section Header: Sayuran Petani
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pilihan Panen Terbaik',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: isDark ? AppColors.textLight : AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          
                          onTap: () => appState.setCategory('Semua'),
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryMint,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Vegetable Grid
                if (filteredVegs.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 60,
                            color: isDark ? AppColors.textMutedDark : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sayuran tidak ditemukan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: isDark ? AppColors.textLight : AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Coba gunakan kata kunci pencarian yang lain.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textMutedDark : Colors.grey,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _searchController.clear();
                              appState.setSearchQuery('');
                              appState.setCategory('Semua');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Reset Filter',
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final veg = filteredVegs[index];
                          return VegetableCard(vegetable: veg);
                        },
                        childCount: filteredVegs.length,
                      ),
                    ),
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

class _HoverableCategoryChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _HoverableCategoryChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_HoverableCategoryChip> createState() => _HoverableCategoryChipState();
}

class _HoverableCategoryChipState extends State<_HoverableCategoryChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.06 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColors.primaryLight
                  : (_isHovered
                      ? (widget.isDark ? AppColors.surfaceDark : AppColors.primarySoft.withOpacity(0.35))
                      : (widget.isDark ? AppColors.cardDark : Colors.white)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isSelected
                    ? AppColors.primaryLight
                    : (_isHovered
                        ? AppColors.primaryMint.withOpacity(0.6)
                        : (widget.isDark ? AppColors.borderDark : AppColors.borderLight)),
                width: widget.isSelected ? 1.5 : 1.0,
              ),
              boxShadow: widget.isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryLight.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : (_isHovered
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: widget.isSelected
                      ? Colors.white
                      : (widget.isDark ? AppColors.textLight : AppColors.textDark),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

