import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_constants.dart';
import '../providers/app_provider.dart';
import '../models/prompt.dart';
import '../utils/app_utils.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  int _currentIndex = 0;
  bool _isExpanded = false;
  List<Prompt> _shuffledPrompts = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    _fadeController.forward();
    _scaleController.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _shufflePrompts();
    });
  }

  void _shufflePrompts() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    _shuffledPrompts = List.from(provider.prompts)..shuffle();
    _currentIndex = 0;
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {});
    AppUtils.mediumHaptic();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.shuffle_rounded,
              color: AppConstants.textOnDark,
              size: 20,
            ),
            const SizedBox(width: AppConstants.paddingS),
            const Text('Prompts shuffled!'),
          ],
        ),
        backgroundColor: AppConstants.infoColor,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }

          if (_shuffledPrompts.isEmpty) {
            return _buildEmptyState();
          }

          return Stack(
            children: [
              // Main content
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                    _isExpanded = false;
                  });
                  AppUtils.lightHaptic();
                },
                itemCount: _shuffledPrompts.length,
                itemBuilder: (context, index) {
                  return _buildPromptCard(_shuffledPrompts[index], index);
                },
              ),
              
              // Top gradient overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppConstants.backgroundColor.withOpacity(0.8),
                        AppConstants.backgroundColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Header with better positioning
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.paddingL),
                    decoration: BoxDecoration(
                      color: AppConstants.backgroundColor.withOpacity(0.95),
                      border: Border(
                        bottom: BorderSide(
                          color: AppConstants.textTertiary.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Discover',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.textPrimary,
                              ),
                            ),
                            Text(
                              '${_shuffledPrompts.length} prompts available',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppConstants.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingS,
                                vertical: AppConstants.paddingXS,
                              ),
                              decoration: BoxDecoration(
                                color: AppConstants.vaultRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                              ),
                              child: Text(
                                '${_currentIndex + 1}/${_shuffledPrompts.length}',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppConstants.vaultRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppConstants.paddingS),
                            IconButton(
                              onPressed: _shufflePrompts,
                              icon: const Icon(Icons.shuffle_rounded),
                              style: IconButton.styleFrom(
                                backgroundColor: AppConstants.surfaceColor.withOpacity(0.8),
                                foregroundColor: AppConstants.vaultRed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPromptCard(Prompt prompt, int index) {
    return Container(
      margin: const EdgeInsets.only(
        left: AppConstants.paddingL,
        right: AppConstants.paddingL,
        top: 120, // Space for header
        bottom: AppConstants.paddingL,
      ),
      child: Stack(
        children: [
          // Main card - Make entire card clickable
          GestureDetector(
            onTap: () {
              AppUtils.mediumHaptic();
              _openFullPrompt(prompt);
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppConstants.surfaceColor,
                    AppConstants.cardColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: AppConstants.vaultRed.withOpacity(0.05),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: PatternPainter(
                          color: AppConstants.vaultRed.withOpacity(0.03),
                        ),
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppConstants.paddingXL,
                        AppConstants.paddingL,
                        AppConstants.paddingXL,
                        AppConstants.paddingXL,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category badge with unique colors
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingM + 2,
                              vertical: AppConstants.paddingS + 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getCategoryColor(prompt.categoryId),
                                  _getCategoryColor(prompt.categoryId).withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(AppConstants.radiusL + 5),
                              boxShadow: [
                                BoxShadow(
                                  color: _getCategoryColor(prompt.categoryId).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              _getCategoryName(prompt.categoryId),
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppConstants.textOnDark,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: AppConstants.paddingL + 4),
                          
                          // Title with enhanced typography
                          Text(
                            prompt.title,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppConstants.textPrimary,
                              height: 1.15,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: AppConstants.paddingM + 2),
                          
                          // Description with better spacing
                          Text(
                            prompt.description,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppConstants.textSecondary,
                              height: 1.5,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const Spacer(),
                          
                          // Content preview with enhanced design
                          Container(
                            padding: const EdgeInsets.all(AppConstants.paddingL + 2),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppConstants.backgroundColor.withOpacity(0.7),
                                  AppConstants.backgroundColor.withOpacity(0.4),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(AppConstants.radiusM + 2),
                              border: Border.all(
                                color: AppConstants.vaultRed.withOpacity(0.1),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(prompt.categoryId).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.auto_awesome_rounded,
                                        size: 16,
                                        color: _getCategoryColor(prompt.categoryId),
                                      ),
                                    ),
                                    const SizedBox(width: AppConstants.paddingS + 2),
                                    Text(
                                      'Prompt Preview',
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: _getCategoryColor(prompt.categoryId),
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppConstants.paddingS + 2),
                                Text(
                                  _getContentPreview(prompt.content),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppConstants.textSecondary,
                                    fontFamily: 'monospace',
                                    height: 1.4,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: AppConstants.paddingL + 2),
                          
                          // Tags with enhanced styling
                          if (prompt.tags.isNotEmpty)
                            Wrap(
                              spacing: AppConstants.paddingS + 2,
                              runSpacing: AppConstants.paddingS,
                              children: prompt.tags.take(3).map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.paddingM + 2,
                                  vertical: AppConstants.paddingXS + 2,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppConstants.infoColor.withOpacity(0.15),
                                      AppConstants.infoColor.withOpacity(0.08),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(AppConstants.radiusS + 2),
                                  border: Border.all(
                                    color: AppConstants.infoColor.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppConstants.infoColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              )).toList(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Action buttons (Instagram-style) with enhanced interactivity
          Positioned(
            right: AppConstants.paddingL,
            bottom: 120,
            child: Column(
              children: [
                Consumer<AppProvider>(
                  builder: (context, provider, child) {
                    final isFav = provider.getFavoritePromptIds().contains(prompt.id);
                    return GestureDetector(
                      onTap: () {
                        AppUtils.mediumHaptic();
                        provider.toggleFavorite(prompt.id);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    isFav ? Icons.heart_broken_rounded : Icons.favorite_rounded,
                                    key: ValueKey(!isFav),
                                    color: AppConstants.textOnDark,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: AppConstants.paddingS),
                                Text(
                                  isFav ? 'Removed from favorites' : 'Added to favorites',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            backgroundColor: isFav ? AppConstants.warningColor : AppConstants.vaultRed,
                            duration: const Duration(milliseconds: 1800),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                            ),
                            margin: const EdgeInsets.all(AppConstants.paddingL),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: isFav 
                            ? LinearGradient(
                                colors: [
                                  AppConstants.vaultRed,
                                  AppConstants.vaultRed.withOpacity(0.8),
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  AppConstants.surfaceColor.withOpacity(0.95),
                                  AppConstants.surfaceColor.withOpacity(0.85),
                                ],
                              ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: isFav 
                              ? AppConstants.vaultRed.withOpacity(0.3)
                              : AppConstants.textTertiary.withOpacity(0.2),
                            width: isFav ? 2.5 : 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isFav 
                                ? AppConstants.vaultRed.withOpacity(0.25)
                                : Colors.black.withOpacity(0.1),
                              blurRadius: isFav ? 12 : 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            key: ValueKey(isFav),
                            size: 24,
                            color: isFav 
                              ? AppConstants.textOnDark
                              : AppConstants.textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppConstants.paddingL),
                _buildEnhancedActionButton(
                  icon: Icons.copy_rounded,
                  onTap: () => _copyPrompt(prompt),
                  tooltip: 'Copy Prompt',
                ),
                const SizedBox(height: AppConstants.paddingL),
                _buildEnhancedActionButton(
                  icon: Icons.share_rounded,
                  onTap: () => _sharePrompt(prompt),
                  tooltip: 'Share Prompt',
                ),
                const SizedBox(height: AppConstants.paddingL),
_buildEnhancedActionButton(
                  icon: Icons.visibility_rounded,
                  onTap: () => _openFullPrompt(prompt),
                  tooltip: 'View Full Prompt',
                  isPrimary: true,
                  categoryColor: AppConstants.vaultRed,
                ),
              ],
            ),
          ),
          
          // Premium badge
          if (prompt.isPremium)
            Positioned(
              top: AppConstants.paddingL,
              right: AppConstants.paddingL,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM,
                  vertical: AppConstants.paddingS,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.warningColor,
                      AppConstants.warningColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.warningColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: AppConstants.textOnDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'PRO',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppConstants.textOnDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
    Color? activeColor,
  }) {
    return GestureDetector(
      onTap: () {
        AppUtils.mediumHaptic();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive 
            ? (activeColor ?? AppConstants.vaultRed).withOpacity(0.2)
            : AppConstants.surfaceColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive 
              ? (activeColor ?? AppConstants.vaultRed)
              : AppConstants.textTertiary.withOpacity(0.2),
            width: isActive ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive 
            ? (activeColor ?? AppConstants.vaultRed)
            : AppConstants.textSecondary,
        ),
      ),
    );
  }

  Widget _buildEnhancedActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
    bool isPrimary = false,
    Color? categoryColor,
  }) {
    final primaryColor = categoryColor ?? AppConstants.vaultRed;
    return GestureDetector(
      onTap: () {
        AppUtils.mediumHaptic();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: isPrimary
            ? LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.8),
                ],
              )
            : LinearGradient(
                colors: [
                  AppConstants.surfaceColor.withOpacity(0.95),
                  AppConstants.surfaceColor.withOpacity(0.85),
                ],
              ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isPrimary
              ? primaryColor.withOpacity(0.3)
              : AppConstants.textTertiary.withOpacity(0.2),
            width: isPrimary ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                ? primaryColor.withOpacity(0.25)
                : Colors.black.withOpacity(0.1),
              blurRadius: isPrimary ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 24,
          color: isPrimary
            ? AppConstants.textOnDark
            : AppConstants.textSecondary,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.vaultRed),
          ),
          const SizedBox(height: AppConstants.paddingL),
          Text(
            'Loading amazing prompts...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.backgroundColor,
            AppConstants.vaultRed.withOpacity(0.05),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discover',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final provider = Provider.of<AppProvider>(context, listen: false);
                      provider.initialize();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppConstants.surfaceColor.withOpacity(0.8),
                      foregroundColor: AppConstants.vaultRed,
                    ),
                  ),
                ],
              ),
              
              // Empty state content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated illustration
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 2),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.8 + (0.2 * value),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  AppConstants.vaultRed.withOpacity(0.2),
                                  AppConstants.vaultRed.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(75),
                            ),
                            child: Icon(
                              Icons.explore_rounded,
                              size: 80,
                              color: AppConstants.vaultRed.withOpacity(0.8),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.paddingXL),
                    
                    Text(
                      'Ready to Discover?',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.paddingM),
                    
                    Text(
                      'Swipe through amazing AI prompts\ntailored just for you!',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppConstants.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: AppConstants.paddingXL),
                    
                    // Feature highlights
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingL),
                      decoration: BoxDecoration(
                        color: AppConstants.surfaceColor,
                        borderRadius: BorderRadius.circular(AppConstants.radiusL),
                        border: Border.all(
                          color: AppConstants.vaultRed.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildFeatureItem(
                            icon: Icons.shuffle_rounded,
                            title: 'Random Discovery',
                            description: 'Find prompts you never knew you needed',
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          _buildFeatureItem(
                            icon: Icons.favorite_rounded,
                            title: 'Save Favorites',
                            description: 'Keep the best prompts for later',
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          _buildFeatureItem(
                            icon: Icons.share_rounded,
                            title: 'Share & Copy',
                            description: 'Easy sharing with one tap',
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.paddingXL),
                    
                    // Action button
                    ElevatedButton.icon(
                      onPressed: () {
                        final provider = Provider.of<AppProvider>(context, listen: false);
                        provider.setCurrentIndex(1); // Go to Categories
                      },
                      icon: const Icon(Icons.category_rounded),
                      label: const Text('Browse Categories'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.vaultRed,
                        foregroundColor: AppConstants.textOnDark,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingXL,
                          vertical: AppConstants.paddingL,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusL),
                        ),
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
  }
  
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingS),
          decoration: BoxDecoration(
            color: AppConstants.vaultRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
          ),
          child: Icon(
            icon,
            color: AppConstants.vaultRed,
            size: 20,
          ),
        ),
        const SizedBox(width: AppConstants.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textPrimary,
                ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getCategoryName(String categoryId) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final category = provider.categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => provider.categories.first,
    );
    return category.name;
  }

  Color _getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'money_making':
        return const Color(0xFF2E7D32); // Deep Green
      case 'content_creation':
        return const Color(0xFF7B1FA2); // Deep Purple
      case 'business_strategy':
        return const Color(0xFF1565C0); // Deep Blue
      case 'freelancing':
        return const Color(0xFFE65100); // Deep Orange
      case 'writing':
        return const Color(0xFF6A1B9A); // Deep Violet
      case 'marketing_sales':
        return const Color(0xFFD32F2F); // Deep Red
      case 'productivity':
        return const Color(0xFF00695C); // Teal
      case 'education':
        return const Color(0xFF5D4037); // Brown
      case 'health_fitness':
        return const Color(0xFF388E3C); // Green
      case 'technology':
        return const Color(0xFF303F9F); // Indigo
      case 'crypto_nft':
        return const Color(0xFFFF6F00); // Amber
      case 'voice_cloning':
        return const Color(0xFF8E24AA); // Purple
      case 'ai_automation':
        return const Color(0xFF0277BD); // Light Blue
      case 'vr_ar':
        return const Color(0xFFAD1457); // Pink
      default:
        return const Color(0xFF424242); // Grey
    }
  }

  String _getContentPreview(String content) {
    // Remove markdown formatting and get clean preview
    String preview = content
        .replaceAll(RegExp(r'#+ '), '')
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1')
        .replaceAll(RegExp(r'\*(.*?)\*'), r'$1')
        .replaceAll(RegExp(r'`(.*?)`'), r'$1')
        .replaceAll(RegExp(r'\n+'), ' ')
        .trim();
    
    return preview.length > 300 ? '${preview.substring(0, 300)}...' : preview;
  }

  bool _shouldShowViewMore(String content) {
    return _getContentPreview(content).length > 200;
  }

  bool _isFavorite(Prompt prompt) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    return provider.favoritePrompts.contains(prompt.id);
  }

  void _toggleFavorite(Prompt prompt) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.toggleFavorite(prompt.id);
  }

  void _copyPrompt(Prompt prompt) {
    Clipboard.setData(ClipboardData(text: prompt.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prompt copied to clipboard'),
        backgroundColor: AppConstants.successColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _sharePrompt(Prompt prompt) {
    Share.share(
      '${prompt.title}\n\n${prompt.description}\n\nGet more AI prompts with Aivellum Pro!',
      subject: prompt.title,
    );
  }

  void _openFullPrompt(Prompt prompt) {
    Navigator.pushNamed(
      context,
      '/prompt-detail',
      arguments: prompt,
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
    
    // Draw diagonal lines
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