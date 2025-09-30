import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/prompt.dart';
import '../providers/app_provider.dart';
import '../screens/prompt_detail_screen.dart';
import '../utils/app_utils.dart';

class PromptCard extends StatefulWidget {
  final Prompt prompt;
  final bool isCompact;

  const PromptCard({
    super.key,
    required this.prompt,
    this.isCompact = false,
  });

  @override
  State<PromptCard> createState() => _PromptCardState();
}

class _PromptCardState extends State<PromptCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
    AppUtils.lightHaptic();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _navigateToDetail() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PromptDetailScreen(prompt: widget.prompt),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: AppConstants.animationMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final category = provider.getCategoryById(widget.prompt.categoryId);
    final categoryColor = AppConstants.categoryColors[widget.prompt.categoryId] ?? AppConstants.cardColor;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: AppConstants.surfaceColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(
                color: _isPressed
                    ? AppConstants.vaultRed.withOpacity(0.2)
                    : AppConstants.textTertiary.withOpacity(0.1),
                width: _isPressed ? 2 : 1,
              ),
              boxShadow: _isPressed
                  ? [
                      BoxShadow(
                        color: AppConstants.vaultRed.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [AppConstants.cardShadow],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _navigateToDetail,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                // Header Row
                Row(
                  children: [
                    // Category Badge
                    if (category != null)
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingM,
                            vertical: AppConstants.paddingS,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor,
                            borderRadius: BorderRadius.circular(AppConstants.radiusL),
                            border: Border.all(
                              color: AppConstants.textTertiary.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                category.icon,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: AppConstants.paddingS),
                              Flexible(
                                child: Text(
                                  category.name,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppConstants.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const Spacer(),

                    // Favorite Button
                    const SizedBox(width: AppConstants.paddingS),
                    Container(
                      decoration: BoxDecoration(
                        color: widget.prompt.isFavorite 
                            ? AppConstants.vaultRed.withOpacity(0.1)
                            : AppConstants.cardColor,
                        borderRadius: BorderRadius.circular(AppConstants.radiusS),
                      ),
                      child: IconButton(
                        onPressed: () {
                          provider.toggleFavorite(widget.prompt.id);
                          AppUtils.lightHaptic();
                        },
                        icon: AnimatedSwitcher(
                          duration: AppConstants.animationFast,
                          child: Icon(
                            widget.prompt.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                            key: ValueKey(widget.prompt.isFavorite),
                            color: widget.prompt.isFavorite ? AppConstants.vaultRed : AppConstants.textTertiary,
                            size: AppConstants.iconSizeSmall,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.paddingM),

                // Title
                Text(
                  widget.prompt.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppConstants.textPrimary,
                  ),
                  maxLines: widget.isCompact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppConstants.paddingS),

                // Description
                Text(
                  widget.prompt.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppConstants.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: widget.isCompact ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                ),

                if (!widget.isCompact) ...[
                  const SizedBox(height: AppConstants.paddingM),

                  // Tags
                  if (widget.prompt.tags.isNotEmpty)
                    Wrap(
                      spacing: AppConstants.paddingS,
                      runSpacing: AppConstants.paddingS,
                      children: widget.prompt.tags.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingM,
                            vertical: AppConstants.paddingS,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.cardColor,
                            borderRadius: BorderRadius.circular(AppConstants.radiusS),
                            border: Border.all(
                              color: AppConstants.textTertiary.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            '#$tag',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppConstants.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: AppConstants.paddingM),

                  // Footer
                  Row(
                    children: [
                      // Difficulty Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingM,
                          vertical: AppConstants.paddingS,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.difficultyColors[widget.prompt.difficulty]?.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                          border: Border.all(
                            color: AppConstants.difficultyColors[widget.prompt.difficulty]?.withOpacity(0.3) ?? 
                                   AppConstants.textTertiary.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              size: 12,
                              color: AppConstants.difficultyColors[widget.prompt.difficulty],
                            ),
                            const SizedBox(width: AppConstants.paddingS),
                            Text(
                              widget.prompt.difficulty,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppConstants.difficultyColors[widget.prompt.difficulty],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: AppConstants.paddingM),

                      // Estimated Time
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: AppConstants.textTertiary,
                          ),
                          const SizedBox(width: AppConstants.paddingS),
                          Text(
                            widget.prompt.estimatedTime,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppConstants.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Action Button - All prompts are accessible in Pro version
                      Container(
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor,
                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _navigateToDetail,
                            borderRadius: BorderRadius.circular(AppConstants.radiusS),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingM,
                                vertical: AppConstants.paddingS,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: AppConstants.textOnDark,
                                  ),
                                  const SizedBox(width: AppConstants.paddingS),
                                  Text(
                                    'View',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppConstants.textOnDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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