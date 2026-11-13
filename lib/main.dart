import 'package:flutter/material.dart';
import 'package:serenia_app/core/service_locator.dart';

void main() {
  setupDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenia',
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}
