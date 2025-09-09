import 'package:cinetrack/features/auth/routes/auth_routes.dart';
import 'package:cinetrack/routes/web_routes.dart';
import 'package:cinetrack/theme/web_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// cor azul de fundo #191530
// roxo #361d57
// botão não selecionado #333a4d
// botão selecionado #ba851a
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: WebTheme().lightTheme,
      routes: WebRoutes.routes,
      initialRoute: AuthRoutes.login,
    );
  }
}
