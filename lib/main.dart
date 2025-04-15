import 'package:flutter/material.dart';
import 'package:safe_travels_3/config/constants.dart';
import 'package:safe_travels_3/config/theme.dart';
import 'package:safe_travels_3/config/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SafeTravelsApp());
}

class SafeTravelsApp extends StatelessWidget {
  const SafeTravelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
