import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/app_provider.dart';
import '../widgets/prompt_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  Future<bool> _onWillPop(AppProvider provider) async {
    provider.setCurrentIndex(0);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return WillPopScope(
          onWillPop: () => _onWillPop(provider),
          child: Scaffold(
            backgroundColor: AppConstants.backgroundColor,
            body: SafeArea(
              child: _buildContent(context, provider),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AppProvider provider) {
    return Consumer<AppProvider>(
          builder: (context, provider, child) {
            final favoritePrompts = provider.favoritePrompts;

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  backgroundColor: AppConstants.backgroundColor,
                  elevation: 0,
                  title: Text(
                    'Favorites',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Empty State or Content
                if (favoritePrompts.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppConstants.paddingXL),
                            decoration: BoxDecoration(
                              color: AppConstants.vaultRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                            ),
                            child: Icon(
                              Icons.favorite_outline,
                              size: 64,
                              color: AppConstants.vaultRed.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingL),
                          Text(
                            'No favorites yet',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppConstants.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingS),
                          Text(
                            'Tap the heart icon on any prompt to add it to your favorites',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppConstants.textTertiary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppConstants.paddingL),
                          ElevatedButton.icon(
                            onPressed: () => provider.setCurrentIndex(1),
                            icon: const Icon(Icons.explore_rounded),
                            label: const Text('Explore Prompts'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.vaultRed,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingXL,
                                vertical: AppConstants.paddingM,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  // Stats
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingM),
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.paddingM),
                        decoration: BoxDecoration(
                          color: AppConstants.surfaceColor,
                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: AppConstants.vaultRed,
                              size: 24,
                            ),
                            const SizedBox(width: AppConstants.paddingM),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${favoritePrompts.length} Favorite Prompts',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Your curated collection',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppConstants.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Favorite Prompts List
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final prompt = favoritePrompts[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: AppConstants.paddingM,
                            right: AppConstants.paddingM,
                            bottom: index == favoritePrompts.length - 1 
                                ? AppConstants.paddingXL 
                                : AppConstants.paddingS,
                          ),
                          child: PromptCard(prompt: prompt),
                        );
                      },
                      childCount: favoritePrompts.length,
                    ),
                  ),
                ],
              ],
            );
          },
        );
  }
}