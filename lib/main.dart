import 'package:currency_app/presentation/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) {
        return MaterialApp(home: MainScreen(), debugShowCheckedModeBanner: false);
      },
    );
  }
}
