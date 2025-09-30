import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_constants.dart';
import '../models/prompt.dart';
import '../providers/app_provider.dart';

class PromptDetailScreen extends StatelessWidget {
  final Prompt prompt;

  const PromptDetailScreen({
    super.key,
    required this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final category = provider.getCategoryById(prompt.categoryId);
          // All prompts are unlocked in Pro version
          final categoryColor = AppConstants.categoryColors[prompt.categoryId] ?? AppConstants.cardColor;

          return CustomScrollView(
            slivers: [
              // Custom App Bar with Hero Section
              SliverAppBar(
                expandedHeight: 280,
                floating: false,
                pinned: true,
                backgroundColor: AppConstants.surfaceColor,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.surfaceColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    boxShadow: [AppConstants.cardShadow],
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: prompt.isFavorite 
                          ? AppConstants.vaultRed.withOpacity(0.1)
                          : AppConstants.surfaceColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                      boxShadow: [AppConstants.cardShadow],
                    ),
                    child: IconButton(
                      onPressed: () => provider.toggleFavorite(prompt.id),
                      icon: Icon(
                        prompt.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                        color: prompt.isFavorite ? AppConstants.vaultRed : AppConstants.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.surfaceColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                      boxShadow: [AppConstants.cardShadow],
                    ),
                    child: IconButton(
                      onPressed: () => _sharePrompt(context),
                      icon: const Icon(
                        Icons.share_rounded,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          categoryColor.withOpacity(0.3),
                          AppConstants.surfaceColor,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.paddingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60), // Space for app bar
                            
                            // Category Badge
                            if (category != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.paddingM,
                                  vertical: AppConstants.paddingS,
                                ),
                                decoration: BoxDecoration(
                                  color: categoryColor,
                                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                                  border: Border.all(
                                    color: AppConstants.textTertiary.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      category.icon,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: AppConstants.paddingS),
                                    Text(
                                      category.name,
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppConstants.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            const SizedBox(height: AppConstants.paddingM),
                            
                            // Title
                            Text(
                              prompt.title,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.textPrimary,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            const SizedBox(height: AppConstants.paddingM),
                            

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppConstants.paddingL),
                        decoration: BoxDecoration(
                          color: AppConstants.surfaceColor,
                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          border: Border.all(
                            color: AppConstants.textTertiary.withOpacity(0.1),
                          ),
                          boxShadow: [AppConstants.cardShadow],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.description_rounded,
                                  color: AppConstants.textSecondary,
                                  size: AppConstants.iconSizeSmall,
                                ),
                                const SizedBox(width: AppConstants.paddingS),
                                Text(
                                  'Description',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.paddingM),
                            Text(
                              prompt.description,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.6,
                                color: AppConstants.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.paddingL),

                      // Metadata Row
                      Row(
                        children: [
                          // Difficulty Badge
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(AppConstants.paddingM),
                              decoration: BoxDecoration(
                                color: AppConstants.difficultyColors[prompt.difficulty]?.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                border: Border.all(
                                  color: AppConstants.difficultyColors[prompt.difficulty]?.withOpacity(0.3) ?? 
                                         AppConstants.textTertiary.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.trending_up_rounded,
                                    color: AppConstants.difficultyColors[prompt.difficulty],
                                    size: AppConstants.iconSizeMedium,
                                  ),
                                  const SizedBox(height: AppConstants.paddingS),
                                  Text(
                                    'Difficulty',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppConstants.textTertiary,
                                    ),
                                  ),
                                  Text(
                                    prompt.difficulty,
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppConstants.difficultyColors[prompt.difficulty],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: AppConstants.paddingM),

                          // Time Badge
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(AppConstants.paddingM),
                              decoration: BoxDecoration(
                                color: AppConstants.infoColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                border: Border.all(
                                  color: AppConstants.infoColor.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.schedule_rounded,
                                    color: AppConstants.infoColor,
                                    size: AppConstants.iconSizeMedium,
                                  ),
                                  const SizedBox(height: AppConstants.paddingS),
                                  Text(
                                    'Duration',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppConstants.textTertiary,
                                    ),
                                  ),
                                  Text(
                                    prompt.estimatedTime,
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppConstants.infoColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppConstants.paddingL),

                      // Tags Section
                      if (prompt.tags.isNotEmpty) ...[
                        Text(
                          'Tags',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingM),
                        Wrap(
                          spacing: AppConstants.paddingS,
                          runSpacing: AppConstants.paddingS,
                          children: prompt.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingM,
                                vertical: AppConstants.paddingS,
                              ),
                              decoration: BoxDecoration(
                                color: AppConstants.cardColor,
                                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                                border: Border.all(
                                  color: AppConstants.textTertiary.withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                '#$tag',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppConstants.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppConstants.paddingL),
                      ],

                      // Content Section
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppConstants.surfaceColor,
                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          border: Border.all(
                            color: AppConstants.successColor.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [AppConstants.cardShadow],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.all(AppConstants.paddingL),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF0FDF4), // Light green background
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(AppConstants.radiusM),
                                  topRight: Radius.circular(AppConstants.radiusM),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppConstants.successColor,
                                    size: AppConstants.iconSizeSmall,
                                  ),
                                  const SizedBox(width: AppConstants.paddingS),
                                  Text(
                                    'Prompt Content',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppConstants.successColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Content
                            Padding(
                              padding: const EdgeInsets.all(AppConstants.paddingL),
                              child: _buildUnlockedContent(context),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.paddingXL),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }



  Widget _buildUnlockedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          prompt.content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingL),
        
        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _copyToClipboard(context),
                icon: const Icon(Icons.copy_rounded),
                label: const Text('Copy'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingM),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _sharePrompt(context),
                icon: const Icon(Icons.share_rounded),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingM),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: prompt.content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Prompt copied to clipboard!'),
          ],
        ),
        backgroundColor: AppConstants.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusS),
        ),
      ),
    );
  }

  void _sharePrompt(BuildContext context) {
    Share.share(
      '${prompt.title}\n\n${prompt.description}\n\nGet more AI prompts at Aivellum!',
      subject: prompt.title,
    );
  }


}