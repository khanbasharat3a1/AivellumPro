import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/app_provider.dart';
import '../widgets/prompt_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/animated_counter.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/pull_to_refresh.dart';
import '../widgets/error_boundary.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, provider, child) {
            return ErrorBoundary(
              errorTitle: 'Failed to load prompts',
              errorMessage: 'We couldn\'t load your AI prompts. Please check your connection and try again.',
              onRetry: provider.initialize,
              child: _buildContent(context, provider),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppProvider provider) {
            if (provider.isLoading) {
              return CustomScrollView(
                slivers: [
                  // Hero Header Skeleton
                  SliverToBoxAdapter(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: Container(
                        margin: const EdgeInsets.all(AppConstants.paddingL),
                        padding: const EdgeInsets.all(AppConstants.paddingXL),
                        decoration: BoxDecoration(
                          color: AppConstants.surfaceColor,
                          borderRadius: BorderRadius.circular(AppConstants.radiusL),
                        ),
                        height: 200,
                      ),
                    ),
                  ),
                  
                  // Stats Skeleton
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
                      child: Row(
                        children: List.generate(3, (index) => 
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < 2 ? AppConstants.paddingM : 0,
                              ),
                              child: ShimmerLoading(
                                isLoading: true,
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppConstants.surfaceColor,
                                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SliverToBoxAdapter(child: SizedBox(height: AppConstants.paddingXL)),
                  
                  // Categories Skeleton
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
                        itemCount: 5,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: AppConstants.paddingM),
                          child: ShimmerLoading(
                            isLoading: true,
                            child: const CategoryCardSkeleton(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SliverToBoxAdapter(child: SizedBox(height: AppConstants.paddingXL)),
                  
                  // Prompts Skeleton
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ShimmerLoading(
                        isLoading: true,
                        child: const PromptCardSkeleton(),
                      ),
                      childCount: 5,
                    ),
                  ),
                ],
              );
            }

            if (provider.error.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppConstants.paddingL),
                        decoration: BoxDecoration(
                          color: AppConstants.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppConstants.radiusL),
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: AppConstants.errorColor,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingL),
                      Text(
                        'Something went wrong',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingS),
                      Text(
                        'We couldn\'t load your prompts. Please try again.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.paddingL),
                      ElevatedButton.icon(
                        onPressed: provider.initialize,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.vaultRed,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final featuredPrompts = provider.getFeaturedPrompts();
            final allCategories = provider.categories;

            return PullToRefresh(
              onRefresh: provider.initialize,
              child: CustomScrollView(
              slivers: [
                // Hero Header Section
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(AppConstants.paddingL),
                    padding: const EdgeInsets.all(AppConstants.paddingXL),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppConstants.vaultRed.withOpacity(0.08),
                          AppConstants.primaryColor.withOpacity(0.05),
                          AppConstants.surfaceColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                      border: Border.all(
                        color: AppConstants.vaultRed.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.vaultRed.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Section
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome to',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppConstants.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: AppConstants.paddingXS),
                                  Row(
                                    children: [
                                      Text(
                                        AppConstants.appName,
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppConstants.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: AppConstants.paddingS),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppConstants.paddingS,
                                          vertical: AppConstants.paddingXS,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: AppConstants.vaultRedGradient,
                                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                                        ),
                                        child: Text(
                                          'AI',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: AppConstants.textOnDark,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppConstants.paddingS),
                                  Text(
                                    'Discover premium AI prompts to boost your creativity and productivity',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppConstants.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // App Icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: AppConstants.vaultRedGradient,
                                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                                boxShadow: [AppConstants.premiumShadow],
                              ),
                              child: Image.asset(
                                'assets/images/logo4.png',
                                width: 40,
                                height: 40,
                                color: AppConstants.textOnDark,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppConstants.paddingL),
                        
                        // Search Bar
                        SearchBarWidget(
                          onChanged: provider.setSearchQuery,
                          onSubmitted: (query) {
                            provider.setCurrentIndex(1);
                          },
                          hintText: 'Search for AI prompts, categories...',
                          suggestions: const [
                            'money making',
                            'business strategy',
                            'content creation',
                            'marketing',
                            'writing',
                          ],
                          showSuggestions: true,
                        ),
                      ],
                    ),
                  ),
                ),

                // Quick Stats
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildQuickStat(
                            context,
                            icon: Icons.auto_awesome_rounded,
                            label: 'Total Prompts',
                            value: provider.totalPrompts,
                            color: AppConstants.infoColor,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingM),
                        Expanded(
                          child: _buildQuickStat(
                            context,
                            icon: Icons.all_inclusive_rounded,
                            label: 'All Included',
                            value: 'PRO',
                            color: AppConstants.successColor,
                            isText: true,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingM),
                        Expanded(
                          child: _buildQuickStat(
                            context,
                            icon: Icons.favorite_rounded,
                            label: 'Favorites',
                            value: provider.favoritePromptsCount,
                            color: AppConstants.vaultRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppConstants.paddingXL)),

                // Categories Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Browse Categories',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            provider.setCurrentIndex(1);
                          },
                          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                          label: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppConstants.paddingM)),

                // Categories Grid - Horizontal Scrolling
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
                      itemCount: allCategories.length,
                      itemBuilder: (context, index) {
                        final category = allCategories[index];
                        final categoryColor = AppConstants.categoryColors[category.id] ?? AppConstants.cardColor;
                        final promptCount = provider.getPromptsByCategory(category.id).length;
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: AppConstants.paddingM),
                          child: GestureDetector(
                            onTap: () {
                              provider.setSelectedCategory(category.id);
                              provider.setCurrentIndex(1);
                            },
                            child: Container(
                              width: 160,
                              padding: const EdgeInsets.all(AppConstants.paddingL),
                              decoration: BoxDecoration(
                                color: AppConstants.surfaceColor,
                                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                                border: Border.all(
                                  color: AppConstants.textTertiary.withOpacity(0.1),
                                ),
                                boxShadow: [AppConstants.cardShadow],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon Container
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: categoryColor,
                                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                    ),
                                    child: Center(
                                      child: Text(
                                        category.icon,
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: AppConstants.paddingM),
                                  
                                  // Category Name and Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                category.name,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // Primary Badge - moved to top right
                                            if (category.isPrimary)
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppConstants.vaultRed.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  '🔥',
                                                  style: const TextStyle(fontSize: 10),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: AppConstants.paddingXS),
                                        Text(
                                          '$promptCount prompts',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: AppConstants.textTertiary,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppConstants.paddingXL)),

                // Featured Prompts Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Featured Prompts',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Handpicked prompts for you',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppConstants.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () {
                            provider.setCurrentIndex(1);
                          },
                          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                          label: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppConstants.paddingM)),

                // Featured Prompts - Vertical List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final prompt = featuredPrompts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingL,
                          vertical: AppConstants.paddingS,
                        ),
                        child: PromptCard(prompt: prompt),
                      );
                    },
                    childCount: featuredPrompts.length,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppConstants.paddingL)),

                // Quick Actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingM),
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickAction(
                                context,
                                icon: Icons.star_rounded,
                                title: 'Pro Features',
                                subtitle: 'All unlocked',
                                color: AppConstants.vaultRed,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('🎉 You already have all Pro features!'),
                                      backgroundColor: AppConstants.successColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: AppConstants.paddingM),
                            Expanded(
                              child: _buildQuickAction(
                                context,
                                icon: Icons.favorite_rounded,
                                title: 'My Favorites',
                                subtitle: '${provider.favoritePromptsCount} saved',
                                color: AppConstants.successColor,
                                onTap: () => provider.setCurrentIndex(2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppConstants.paddingXL * 2)),
              ],
              ),
            );
  }

  Widget _buildQuickStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required dynamic value,
    required Color color,
    bool isText = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppConstants.textTertiary.withOpacity(0.1),
        ),
        boxShadow: [AppConstants.cardShadow],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppConstants.iconSizeMedium,
          ),
          const SizedBox(height: AppConstants.paddingS),
          if (isText)
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            )
          else
            AnimatedCounter(
              value: value is int ? value : int.tryParse(value.toString()) ?? 0,
              textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
          boxShadow: [AppConstants.cardShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingS),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Icon(
                icon,
                color: color,
                size: AppConstants.iconSizeMedium,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingXS),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}