import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/theme.dart';
import 'package:serenia_app/features/home/presentation/home_page.dart';
import 'package:serenia_app/features/iam/application/is_signed_in_use_case.dart';
import 'package:serenia_app/features/iam/presentation/welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  final bool signedIn = await getIt<IsSignedInUseCase>().execute();
  runApp(MainApp(signedIn: signedIn));
}

class MainApp extends StatelessWidget {
  final bool _signedIn;

  const new({super.key, required this._signedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenia',
      debugShowCheckedModeBanner: false,
      theme: MaterialTheme(SereniaTypography.familiar).light(),
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: child!,
      ),
      home: _signedIn ? const HomePage() : const WelcomePage(),
    );
  }
}
