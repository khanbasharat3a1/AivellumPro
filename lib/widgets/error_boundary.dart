import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final String? errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorTitle,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    return widget.child;
  }

  Widget _buildErrorWidget() {
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
              child: const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppConstants.errorColor,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingL),
            
            Text(
              widget.errorTitle ?? 'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppConstants.paddingS),
            
            Text(
              widget.errorMessage ?? 'An unexpected error occurred. Please try again.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (widget.onRetry != null) ...[
              const SizedBox(height: AppConstants.paddingL),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _error = null;
                  });
                  widget.onRetry?.call();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.vaultRed,
                ),
              ),
            ],
            
            const SizedBox(height: AppConstants.paddingM),
            
            // Debug info in debug mode
            if (AppConstants.isDebugMode && _error != null)
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingM),
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Text(
                  'Debug: ${_error.toString()}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textTertiary,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleError(Object error) {
    setState(() {
      _hasError = true;
      _error = error;
    });
  }
}

// Extension to wrap widgets with error boundary
extension ErrorBoundaryExtension on Widget {
  Widget withErrorBoundary({
    String? errorTitle,
    String? errorMessage,
    VoidCallback? onRetry,
  }) {
    return ErrorBoundary(
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      onRetry: onRetry,
      child: this,
    );
  }
}