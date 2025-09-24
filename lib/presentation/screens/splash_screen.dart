import 'package:amritha_ayurveda/presentation/screens/auth/sign_in_screen.dart';
import 'package:amritha_ayurveda/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

/// Splash screen that shows app logo and handles initial navigation
class SplashScreen extends StatefulWidget {
  static const route = '/splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  void _checkAuthenticationStatus() async {
    // Wait for a minimum splash duration
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Wait for auth initialization to complete
    while (authProvider.state == AuthState.initial || authProvider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }

    // Navigate based on authentication state
    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    } else {
      Navigator.of(context).pushReplacementNamed(SignInScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.pureWhite,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.spa,
                size: 60,
                color: AppTheme.primaryGreen,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
