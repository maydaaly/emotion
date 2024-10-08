import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/person_provider.dart';
import 'screens/popular_people_screen.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: PopularPeopleScreen(),
    );
  }
}
