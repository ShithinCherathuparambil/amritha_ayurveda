import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/theme_provider.dart';
import '../presentation/providers/treatment_provider.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
  ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
  ChangeNotifierProvider<TreatmentProvider>(create: (_) => TreatmentProvider()),
];
