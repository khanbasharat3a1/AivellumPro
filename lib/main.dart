import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';
import 'providers/app_provider.dart';
import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/about_screen.dart';
import 'screens/prompt_detail_screen.dart';
import 'models/prompt.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const AivellumProApp());
}

class AivellumProApp extends StatelessWidget {
  const AivellumProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: 'Aivellum Pro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/main': (context) => const MainScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/about': (context) => const AboutScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/prompt-detail') {
            final prompt = settings.arguments as Prompt;
            return MaterialPageRoute(
              builder: (context) => PromptDetailScreen(prompt: prompt),
            );
          }
          return null;
        },
      ),
    );
  }
}