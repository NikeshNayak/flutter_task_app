import 'package:flutter/material.dart';
import 'package:flutter_task_app/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Task',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: const MainScreen(),
    );
  }
}
