import 'package:cinetrack/features/auth/routes/auth_routes.dart';
import 'package:cinetrack/routes/web_routes.dart';
import 'package:cinetrack/theme/web_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cinetrack/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Removido dotenv - só funciona localmente, não no Flutter Web
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: WebTheme().darkTheme,
      routes: WebRoutes.routes,
      initialRoute: AuthRoutes.login,
    );
  }
}
