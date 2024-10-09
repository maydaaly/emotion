import 'package:emotion/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/person_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PersonProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Popular People App',
      theme: ThemeData(
        primaryColor: Colors.purple.shade600,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple.shade600,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.orange.shade600,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white60,
          indicator: BoxDecoration(
            color: Colors.purple.shade600,
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.orange.shade600,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
