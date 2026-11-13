import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/theme.dart';

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
      theme: MaterialTheme(SereniaTypography.familiar).light(),
      home: Scaffold(),
    );
  }
}
