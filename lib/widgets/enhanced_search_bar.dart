import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/app_utils.dart';

class EnhancedSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final String hintText;
  final List<String> suggestions;
  final bool showSuggestions;

  const EnhancedSearchBar({
    super.key,
    required this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search...',
    this.suggestions = const [],
    this.showSuggestions = false,
  });

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _showClearButton) {
      setState(() {
        _showClearButton = hasText;
      });
    }

    // Debounced search
    AppUtils.debounce(() {
      widget.onChanged(_controller.text);
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged('');
    AppUtils.lightHaptic();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppConstants.surfaceColor,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            border: Border.all(
              color: _isFocused
                  ? AppConstants.vaultRed.withOpacity(0.3)
                  : AppConstants.textTertiary.withOpacity(0.2),
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppConstants.vaultRed.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [AppConstants.cardShadow],
          ),
          child: Row(
            children: [
              // Search Icon
              Padding(
                padding: const EdgeInsets.only(left: AppConstants.paddingM),
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_scaleAnimation.value * 0.1),
                      child: Icon(
                        Icons.search_rounded,
                        color: _isFocused
                            ? AppConstants.vaultRed
                            : AppConstants.textTertiary,
                        size: AppConstants.iconSizeMedium,
                      ),
                    );
                  },
                ),
              ),

              // Text Field
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: AppConstants.textTertiary,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM,
                      vertical: AppConstants.paddingM,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppConstants.textPrimary,
                  ),
                ),
              ),

              // Clear Button
              if (_showClearButton)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppConstants.paddingS),
                    child: IconButton(
                      onPressed: _clearSearch,
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: AppConstants.textTertiary,
                        size: AppConstants.iconSizeSmall,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),

              // Voice Search Button (placeholder for future feature)
              if (!_showClearButton && _isFocused)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppConstants.paddingS),
                    child: IconButton(
                      onPressed: () {
                        AppUtils.lightHaptic();
                        // TODO: Implement voice search
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Voice search coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.mic_rounded,
                        color: AppConstants.textTertiary,
                        size: AppConstants.iconSizeSmall,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Search Suggestions
        if (widget.showSuggestions && widget.suggestions.isNotEmpty && _isFocused)
          AnimatedContainer(
            duration: AppConstants.animationFast,
            margin: const EdgeInsets.only(top: AppConstants.paddingS),
            decoration: BoxDecoration(
              color: AppConstants.surfaceColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(
                color: AppConstants.textTertiary.withOpacity(0.1),
              ),
              boxShadow: [AppConstants.cardShadow],
            ),
            child: Column(
              children: widget.suggestions.take(5).map((suggestion) {
                return ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.history_rounded,
                    size: AppConstants.iconSizeSmall,
                    color: AppConstants.textTertiary,
                  ),
                  title: Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  onTap: () {
                    _controller.text = suggestion;
                    widget.onChanged(suggestion);
                    _focusNode.unfocus();
                    AppUtils.selectionHaptic();
                  },
                  trailing: IconButton(
                    onPressed: () {
                      // TODO: Remove suggestion from history
                      AppUtils.lightHaptic();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      size: AppConstants.iconSizeSmall,
                      color: AppConstants.textTertiary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}