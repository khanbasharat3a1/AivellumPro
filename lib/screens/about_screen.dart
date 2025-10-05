import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('About Aivellum Pro'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Name Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppConstants.vaultRedGradient,
                      borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                      boxShadow: [AppConstants.premiumShadow],
                    ),
                    child: Image.asset(
                      'assets/images/logo4.png',
                      width: 50,
                      height: 50,
                      color: AppConstants.textOnDark,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingL),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingS),
                  Text(
                    'Version $_version',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingXL * 2),

            // About Section
            _buildSection(
              title: 'About Aivellum Pro',
              content: 'Aivellum Pro is the ultimate premium AI prompts vault designed for creators, entrepreneurs, and professionals. Our carefully curated collection of AI prompts helps you unlock your creative potential and boost productivity across various domains.',
              icon: Icons.info_outline_rounded,
              color: AppConstants.infoColor,
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // Features Section
            _buildSection(
              title: 'What Makes Us Special',
              content: '• All Premium Prompts Unlocked\n• No Ads or Distractions\n• Offline Access Available\n• Regular Content Updates\n• Professional Quality Prompts\n• Multiple Categories Covered',
              icon: Icons.star_outline_rounded,
              color: AppConstants.vaultRed,
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // Mission Section
            _buildSection(
              title: 'Our Mission',
              content: 'We believe in democratizing access to high-quality AI prompts. Our mission is to empower creators and professionals with the tools they need to harness the full potential of AI technology.',
              icon: Icons.rocket_launch_outlined,
              color: AppConstants.successColor,
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // Developer Section
            _buildSection(
              title: 'Developer',
              content: 'Developed with ❤️ by Khan Basharat\nPassionate Flutter developer creating innovative tools that enhance productivity and creativity for professionals worldwide.',
              icon: Icons.code_rounded,
              color: AppConstants.warningColor,
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // Contact Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.vaultRed.withOpacity(0.1),
                    AppConstants.primaryColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                border: Border.all(
                  color: AppConstants.vaultRed.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppConstants.paddingS),
                        decoration: BoxDecoration(
                          color: AppConstants.vaultRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                        ),
                        child: Icon(
                          Icons.contact_support_outlined,
                          color: AppConstants.vaultRed,
                          size: AppConstants.iconSizeMedium,
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingM),
                      Text(
                        'Get in Touch',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  Text(
                    'Have questions, suggestions, or feedback? We\'d love to hear from you!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppConstants.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingL),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            try {
                              final Uri emailUri = Uri.parse('mailto:khanbasharat3a1@gmail.com?subject=Aivellum Pro - Feedback&body=Hello Khan,%0A%0A');
                              await launchUrl(emailUri, mode: LaunchMode.externalApplication);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Email: khanbasharat3a1@gmail.com'),
                                  backgroundColor: AppConstants.infoColor,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.email_outlined),
                          label: const Text('Email Us'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstants.vaultRed,
                            side: BorderSide(color: AppConstants.vaultRed.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // Copyright
            Center(
              child: Column(
                children: [
                  Text(
                    '© 2025 Aivellum Pro. All rights reserved.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.textTertiary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingXS),
                  Text(
                    'Made with ❤️ for AI enthusiasts worldwide',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.textTertiary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
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
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingS),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: AppConstants.iconSizeMedium,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppConstants.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}