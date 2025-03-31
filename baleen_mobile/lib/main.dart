import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'navigation/app_router.dart';

void main() {
  runApp(const BaleenApp());
}

class BaleenApp extends StatelessWidget {
  const BaleenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baleen',
      theme: AppTheme.darkTheme,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
