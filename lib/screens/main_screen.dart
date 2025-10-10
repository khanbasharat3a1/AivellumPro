import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'discover_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime? _lastBackPress;

  Future<bool> _onWillPop(BuildContext context, AppProvider provider) async {
    // If not on home screen, go to home
    if (provider.currentIndex != 0) {
      provider.setCurrentIndex(0);
      return false;
    }
    
    // If on home screen, show exit confirmation with double tap
    final now = DateTime.now();
    if (_lastBackPress == null || now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      _lastBackPress = now;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Press back again to exit'),
            ],
          ),
          backgroundColor: AppConstants.textPrimary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return WillPopScope(
          onWillPop: () => _onWillPop(context, provider),
          child: Scaffold(
          body: IndexedStack(
            index: provider.currentIndex,
            children: const [
              HomeScreen(),
              CategoriesScreen(),
              DiscoverScreen(),
              FavoritesScreen(),
              SettingsScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppConstants.surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingS,
                  vertical: AppConstants.paddingS,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context,
                      icon: Icons.home_rounded,
                      outlineIcon: Icons.home_outlined,
                      label: 'Home',
                      index: 0,
                      isSelected: provider.currentIndex == 0,
                      onTap: () => provider.setCurrentIndex(0),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.category_rounded,
                      outlineIcon: Icons.category_outlined,
                      label: 'Categories',
                      index: 1,
                      isSelected: provider.currentIndex == 1,
                      onTap: () => provider.setCurrentIndex(1),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.explore_rounded,
                      outlineIcon: Icons.explore_outlined,
                      label: 'Discover',
                      index: 2,
                      isSelected: provider.currentIndex == 2,
                      onTap: () => provider.setCurrentIndex(2),
                      isPremium: true,
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.favorite_rounded,
                      outlineIcon: Icons.favorite_outline_rounded,
                      label: 'Favorites',
                      index: 3,
                      isSelected: provider.currentIndex == 3,
                      onTap: () => provider.setCurrentIndex(3),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.settings_rounded,
                      outlineIcon: Icons.settings_outlined,
                      label: 'Settings',
                      index: 4,
                      isSelected: provider.currentIndex == 4,
                      onTap: () => provider.setCurrentIndex(4),
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

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData outlineIcon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.paddingS,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with background
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingS),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? (isPremium ? AppConstants.vaultRed : AppConstants.primaryColor).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Icon(
                  isSelected ? icon : outlineIcon,
                  size: AppConstants.iconSizeMedium,
                  color: isSelected 
                      ? (isPremium ? AppConstants.vaultRed : AppConstants.primaryColor)
                      : AppConstants.textTertiary,
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingXS),
              
              // Label
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected 
                      ? (isPremium ? AppConstants.vaultRed : AppConstants.primaryColor)
                      : AppConstants.textTertiary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Selection indicator
              if (isSelected) ...[
                const SizedBox(height: AppConstants.paddingXS),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isPremium ? AppConstants.vaultRed : AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}