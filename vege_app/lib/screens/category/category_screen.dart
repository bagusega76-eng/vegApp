import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../state/app_state.dart';
import '../../widgets/vegetable_card.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = AppState();

    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final categories = [
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

        final filteredVegs = appState.vegetables.where((v) {
          if (appState.selectedCategory == 'Semua') return true;
          if (appState.selectedCategory == 'Organik') return v.isOrganic;
          return v.category.toLowerCase() == appState.selectedCategory.toLowerCase();
        }).toList();

        return Scaffold(
          backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            elevation: 0,
            title: Text(
              'Jelajah Kategori Segar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category horizontal list
              SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = appState.selectedCategory == cat;

                    return InkWell(
                      onTap: () => appState.setCategory(cat),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryLight
                              : (isDark ? AppColors.cardDark : Colors.white),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryLight
                                : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.textLight : AppColors.textDark),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Menampilkan ${filteredVegs.length} produk di kategori "${appState.selectedCategory}"',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: filteredVegs.length,
                  itemBuilder: (context, index) {
                    return VegetableCard(vegetable: filteredVegs[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
