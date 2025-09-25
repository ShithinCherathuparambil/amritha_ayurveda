import 'package:amritha_ayurveda/config/app_routes.dart';
import 'package:amritha_ayurveda/core/constants/app_constants.dart';
import 'package:amritha_ayurveda/core/utils/easy_loading_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/providers.dart';
import 'config/url.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Validate environment configuration
  if (ApiUrls.validateEnvironment()) {
    ApiUrls.printUrls();
  }

  configLoading();
  runApp(const AmrithaAyurvedaApp());
}

class AmrithaAyurvedaApp extends StatelessWidget {
  const AmrithaAyurvedaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: ScreenUtilInit(
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
          onGenerateRoute: onAppGenerateRoute(),
          home: const SplashScreen(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}
