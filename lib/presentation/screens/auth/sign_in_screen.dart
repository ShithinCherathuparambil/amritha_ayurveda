import 'dart:developer';

import 'package:amritha_ayurveda/core/utils/text_styles.dart';
import 'package:amritha_ayurveda/presentation/screens/home/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import 'sign_up_screen.dart';

/// Sign in screen for user authentication
class SignInScreen extends StatefulWidget {
  static const route = '/sign_in_screen';
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
  void initState() {
    super.initState();
    if (kDebugMode) {
      _emailController.text = 'test_user';
      _passwordController.text = '12345678';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softGray,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(  
                'assets/images/login_logo.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Center(
                child: Align(
                  child: Image.asset(  
                    'assets/images/logo.png',
                    width: 80.h,
                    height: 80.h,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding:   EdgeInsets.symmetric(horizontal: 16.0),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 40),
                              
                           Text(
                             'Login Or Register To Book Your\nAppointments',
                             style: ts24c000940w4h1,
                             textAlign: TextAlign.start,
                           ),
                              
                          const SizedBox(height: 48),
                              
                          // Email Field
                          Text('Email'),
                          SizedBox(height: 8),
                          TextFormField(controller: _emailController),
                              
                          const SizedBox(height: 16),
                              
                          // Password Field
                               Text('Password'),
                          SizedBox(height: 8),
                          TextFormField(controller: _passwordController),
                          const SizedBox(height: 8),
                              
                                         
                              
                          const SizedBox(height: 24),
                              
                          // Error Message
                          // if (authProvider.errorMessage != null)
                               
                          // Sign In Button
                          ElevatedButton(
                            onPressed: () => _signIn(),
                            child: Text('Login'),
                          ),
                              
                          const SizedBox(height: 24),
                              
                       
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),                                   SafeArea(child: Padding(
            padding:   EdgeInsets.symmetric(horizontal: 16.w),
            child: Text('By creating or logging into an account you are agreeing with our Terms and Conditions and Privacy Policy.'),
          ))

        ],
      ),
    );
  }

  void _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        EasyLoading.show();
        await authProvider.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        EasyLoading.dismiss();
      }

      if (authProvider.isAuthenticated) {
        // Navigate to home screen
        Navigator.of(context).pushReplacementNamed(HomeScreen.route);
      } else if (authProvider.errorMessage != null) {
        log('${authProvider.errorMessage}');
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
