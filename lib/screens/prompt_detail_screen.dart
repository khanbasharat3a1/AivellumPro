import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_constants.dart';
import '../providers/app_provider.dart';
import '../models/prompt.dart';
import '../utils/app_utils.dart';

class PromptDetailScreen extends StatefulWidget {
  final Prompt prompt;

  const PromptDetailScreen({super.key, required this.prompt});

  @override
  State<PromptDetailScreen> createState() => _PromptDetailScreenState();
}

class _PromptDetailScreenState extends State<PromptDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 100;
      });
    });
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App bar
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: _isScrolled 
                  ? AppConstants.surfaceColor 
                  : Colors.transparent,
                elevation: _isScrolled ? 4 : 0,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.surfaceColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: _sharePrompt,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.surfaceColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.share_rounded),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppConstants.vaultRed.withOpacity(0.1),
                          AppConstants.primaryColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Pattern overlay
                        Positioned.fill(
                          child: CustomPaint(
                            painter: PatternPainter(
                              color: AppConstants.vaultRed.withOpacity(0.05),
                            ),
                          ),
                        ),
                        // Content
                        Positioned(
                          bottom: 60,
                          left: AppConstants.paddingL,
                          right: AppConstants.paddingL,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppConstants.paddingM,
                                      vertical: AppConstants.paddingS,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: AppConstants.vaultRedGradient,
                                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                    ),
                                    child: Text(
                                      _getCategoryName(),
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: AppConstants.textOnDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppConstants.paddingM),
                                  // Title
                                  Text(
                                    widget.prompt.title,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Content
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Description
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppConstants.paddingL),
                            decoration: BoxDecoration(
                              color: AppConstants.surfaceColor,
                              borderRadius: BorderRadius.circular(AppConstants.radiusL),
                              border: Border.all(
                                color: AppConstants.textTertiary.withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.description_rounded,
                                      size: 20,
                                      color: AppConstants.vaultRed,
                                    ),
                                    const SizedBox(width: AppConstants.paddingS),
                                    Text(
                                      'Description',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppConstants.vaultRed,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppConstants.paddingM),
                                Text(
                                  widget.prompt.description,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppConstants.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: AppConstants.paddingL),
                          
                          // Prompt content
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppConstants.paddingL),
                            decoration: BoxDecoration(
                              color: AppConstants.backgroundColor,
                              borderRadius: BorderRadius.circular(AppConstants.radiusL),
                              border: Border.all(
                                color: AppConstants.vaultRed.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.auto_awesome_rounded,
                                          size: 20,
                                          color: AppConstants.vaultRed,
                                        ),
                                        const SizedBox(width: AppConstants.paddingS),
                                        Text(
                                          'AI Prompt',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppConstants.vaultRed,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: _copyPrompt,
                                      icon: const Icon(Icons.copy_rounded),
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppConstants.vaultRed.withOpacity(0.1),
                                        foregroundColor: AppConstants.vaultRed,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppConstants.paddingM),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(AppConstants.paddingL),
                                  decoration: BoxDecoration(
                                    color: AppConstants.surfaceColor,
                                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                  ),
                                  child: SelectableText(
                                    widget.prompt.content,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontFamily: 'monospace',
                                      color: AppConstants.textPrimary,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: AppConstants.paddingL),
                          
                          // Metadata
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetadataCard(
                                  icon: Icons.schedule_rounded,
                                  label: 'Time',
                                  value: widget.prompt.estimatedTime,
                                  color: AppConstants.infoColor,
                                ),
                              ),
                              const SizedBox(width: AppConstants.paddingM),
                              Expanded(
                                child: _buildMetadataCard(
                                  icon: Icons.trending_up_rounded,
                                  label: 'Level',
                                  value: widget.prompt.difficulty,
                                  color: _getDifficultyColor(),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: AppConstants.paddingL),
                          
                          // Tags
                          if (widget.prompt.tags.isNotEmpty) ...[
                            Text(
                              'Tags',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppConstants.paddingM),
                            Wrap(
                              spacing: AppConstants.paddingS,
                              runSpacing: AppConstants.paddingS,
                              children: widget.prompt.tags.map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.paddingM,
                                  vertical: AppConstants.paddingS,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConstants.infoColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                  border: Border.all(
                                    color: AppConstants.infoColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppConstants.infoColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )).toList(),
                            ),
                            const SizedBox(height: AppConstants.paddingXL),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Floating action buttons
          Positioned(
            bottom: 30,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'favorite',
                  onPressed: _toggleFavorite,
                  backgroundColor: _isFavorite() 
                    ? AppConstants.errorColor 
                    : AppConstants.surfaceColor,
                  foregroundColor: _isFavorite() 
                    ? AppConstants.textOnDark 
                    : AppConstants.textSecondary,
                  child: Icon(_isFavorite() ? Icons.favorite : Icons.favorite_border),
                ),
                const SizedBox(height: AppConstants.paddingM),
                FloatingActionButton(
                  heroTag: 'copy',
                  onPressed: _copyPrompt,
                  backgroundColor: AppConstants.vaultRed,
                  foregroundColor: AppConstants.textOnDark,
                  child: const Icon(Icons.copy_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppConstants.iconSizeMedium,
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final category = provider.categories.firstWhere(
      (cat) => cat.id == widget.prompt.categoryId,
      orElse: () => provider.categories.first,
    );
    return category.name;
  }

  Color _getDifficultyColor() {
    switch (widget.prompt.difficulty.toLowerCase()) {
      case 'beginner':
        return AppConstants.successColor;
      case 'intermediate':
        return AppConstants.warningColor;
      case 'advanced':
        return AppConstants.errorColor;
      case 'expert':
        return AppConstants.vaultRed;
      default:
        return AppConstants.infoColor;
    }
  }

  bool _isFavorite() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    return provider.favoritePrompts.contains(widget.prompt.id);
  }

  void _toggleFavorite() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.toggleFavorite(widget.prompt.id);
    AppUtils.mediumHaptic();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite() ? 'Added to favorites' : 'Removed from favorites',
        ),
        backgroundColor: AppConstants.successColor,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _copyPrompt() {
    Clipboard.setData(ClipboardData(text: widget.prompt.content));
    AppUtils.mediumHaptic();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prompt copied to clipboard'),
        backgroundColor: AppConstants.successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _sharePrompt() {
    Share.share(
      '${widget.prompt.title}\n\n${widget.prompt.description}\n\nGet more AI prompts with Aivellum Pro!',
      subject: widget.prompt.title,
    );
  }
}

class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 30.0;
    
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}