import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Aivellum Pro',
      description: 'Discover premium AI prompts designed to boost your creativity and productivity',
      icon: '🚀',
      gradient: [AppConstants.vaultRed, AppConstants.primaryColor],
    ),
    OnboardingPage(
      title: 'All Prompts Unlocked',
      description: 'Access thousands of premium AI prompts without any restrictions or limitations',
      icon: '🔓',
      gradient: [AppConstants.successColor, AppConstants.infoColor],
    ),
    OnboardingPage(
      title: 'No Ads, No Limits',
      description: 'Enjoy a clean, distraction-free experience with all features included',
      icon: '✨',
      gradient: [AppConstants.warningColor, AppConstants.vaultRed],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.backgroundColor,
              AppConstants.surfaceColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingL),
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: AppConstants.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppConstants.vaultRed
                          : AppConstants.textTertiary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingXL),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingL),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppConstants.vaultRed.withOpacity(0.3)),
                          ),
                          child: const Text('Previous'),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: AppConstants.paddingM),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _currentPage == _pages.length - 1
                            ? _completeOnboarding
                            : () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.vaultRed,
                          foregroundColor: AppConstants.textOnDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
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

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: page.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: page.gradient.first.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                page.icon,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingXL * 2),

          // Title
          Text(
            page.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.paddingL),

          // Description
          Text(
            page.description,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppConstants.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String icon;
  final List<Color> gradient;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}