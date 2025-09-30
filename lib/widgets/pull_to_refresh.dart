import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/app_utils.dart';

class PullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final String refreshText;

  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.refreshText = 'Pull to refresh',
  });

  @override
  State<PullToRefresh> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends State<PullToRefresh>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    _animationController.repeat();
    AppUtils.mediumHaptic();

    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppConstants.vaultRed,
      backgroundColor: AppConstants.surfaceColor,
      strokeWidth: 3,
      displacement: 60,
      child: widget.child,
    );
  }
}