import 'package:amritha_ayurveda/config/app_routes.dart';
import 'package:amritha_ayurveda/core/constants/app_constants.dart';
import 'package:amritha_ayurveda/core/utils/easy_loading_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/providers.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
  runApp(const AmrithaAyurvedaApp());
}

class AmrithaAyurvedaApp extends StatelessWidget {
  const AmrithaAyurvedaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ScreenUtilInit(
            designSize: const Size(
              AppConstants.designWidth,
              AppConstants.designHeight,
            ),
            enableScaleWH: () => false,
            enableScaleText: () => false,
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
              title: 'Amritha Ayurveda',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              onGenerateRoute: onAppGenerateRoute(),
              home: const SplashScreen(),
              builder: EasyLoading.init(),
            ),
          );
        },
      ),
    );
  }
}
