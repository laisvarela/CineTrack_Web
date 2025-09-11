import 'package:cinetrack/features/auth/routes/auth_routes.dart';
import 'package:cinetrack/routes/web_routes.dart';
import 'package:cinetrack/theme/web_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cinetrack/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  runApp(ProviderScope(child: const MyApp()));
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
      theme: WebTheme().darkTheme,
      routes: WebRoutes.routes,
      initialRoute: AuthRoutes.login,
    );
  }
}
