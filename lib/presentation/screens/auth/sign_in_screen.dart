import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import 'sign_up_screen.dart';

/// Sign in screen for user authentication
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {}

  void _navigateToSignUp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softGray,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Logo and Welcome Text
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Icon(
                              Icons.spa,
                              size: 40,
                              color: AppTheme.pureWhite,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Welcome Back',
                            style: AppTheme.headingLarge.copyWith(
                              color: AppTheme.darkGreen,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to continue your wellness journey',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.darkGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Email Field
                    TextFormField(controller: _emailController),

                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(controller: _passwordController),
                    const SizedBox(height: 8),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Forgot password feature coming soon!',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Error Message
                    // if (authProvider.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.errorRed.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppTheme.errorRed,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'authProvider.errorMessage',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.errorRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Sign In Button
                    ElevatedButton(onPressed: () {}, child: child),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.darkGray,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.darkGray,
                          ),
                        ),
                        GestureDetector(
                          onTap: _navigateToSignUp,
                          child: Text(
                            'Sign Up',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Demo Credentials
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightGreen.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Demo Credentials:',
                            style: AppTheme.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkGreen,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Email: john.doe@example.com\nPassword: password123',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.darkGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
