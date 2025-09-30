import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_constants.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Shimmer.fromColors(
      baseColor: AppConstants.cardColor,
      highlightColor: AppConstants.surfaceColor,
      child: child,
    );
  }
}

class PromptCardSkeleton extends StatelessWidget {
  const PromptCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingL,
        vertical: AppConstants.paddingS,
      ),
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppConstants.textTertiary.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
              ),
              const Spacer(),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.paddingM),
          
          // Title
          Container(
            width: double.infinity,
            height: 20,
            decoration: BoxDecoration(
              color: AppConstants.cardColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          
          const SizedBox(height: AppConstants.paddingS),
          
          // Description lines
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: AppConstants.cardColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          
          const SizedBox(height: AppConstants.paddingXS),
          
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 16,
            decoration: BoxDecoration(
              color: AppConstants.cardColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          
          const SizedBox(height: AppConstants.paddingM),
          
          // Tags
          Row(
            children: [
              Container(
                width: 60,
                height: 24,
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
              ),
              const SizedBox(width: AppConstants.paddingS),
              Container(
                width: 50,
                height: 24,
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.paddingM),
          
          // Footer
          Row(
            children: [
              Container(
                width: 70,
                height: 24,
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Container(
                width: 60,
                height: 24,
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
              ),
              const Spacer(),
              Container(
                width: 60,
                height: 32,
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryCardSkeleton extends StatelessWidget {
  const CategoryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
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
          // Icon container
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppConstants.cardColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
          ),
          
          const SizedBox(height: AppConstants.paddingM),
          
          // Category name
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: AppConstants.cardColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          
          const SizedBox(height: AppConstants.paddingS),
          
          // Prompt count
          Container(
            width: 80,
            height: 12,
            decoration: BoxDecoration(
              color: AppConstants.cardColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}