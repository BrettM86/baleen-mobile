import 'package:flutter/material.dart';
import 'screens/post_list_screen.dart';
import 'constants/app_theme.dart';

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
      home: const PostListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
