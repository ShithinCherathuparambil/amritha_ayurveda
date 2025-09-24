import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/providers.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(const AmrithaAyurvedaApp());
}

class AmrithaAyurvedaApp extends StatelessWidget {
  const AmrithaAyurvedaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Amritha Ayurveda',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
