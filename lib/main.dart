import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/theme.dart';
import 'package:serenia_app/features/carecircle/application/has_family_link_use_case.dart';
import 'package:serenia_app/features/carecircle/presentation/relationship_page.dart';
import 'package:serenia_app/features/iam/application/is_signed_in_use_case.dart';
import 'package:serenia_app/features/iam/application/sign_out_use_case.dart';
import 'package:serenia_app/features/iam/presentation/welcome_page.dart';
import 'package:serenia_app/features/main/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(MainApp(home: await _startPage()));
}

Future<Widget> _startPage() async {
  if (!await getIt<IsSignedInUseCase>().execute()) {
    return const WelcomePage();
  }
  try {
    final bool hasFamilyLink = await getIt<HasFamilyLinkUseCase>().execute();
    return hasFamilyLink ? const MainPage() : const RelationshipPage();
  } on ApiException catch (e) {
    if (e.statusCode == HttpStatus.unauthorized) {
      await getIt<SignOutUseCase>().execute();
      return const WelcomePage();
    }
    return const MainPage();
  } catch (_) {
    return const MainPage();
  }
}

class MainApp extends StatelessWidget {
  final Widget _home;

  const new({super.key, required this._home});

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
      home: _home,
    );
  }
}
