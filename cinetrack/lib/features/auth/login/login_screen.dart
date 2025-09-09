import 'package:cinetrack/core/asset_images.dart';
import 'package:cinetrack/features/auth/routes/auth_routes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // primeira camada de fundo: container com textura granulada
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF191530),
              image: DecorationImage(
                image: AssetImage(AssetImages.mainBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // camada da frente: container central semi-transparente
          Center(
            child: Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 30,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFcd90f5).withAlpha(50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFcd90f5), width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      AssetImages.mainIcon,
                      width: 75,
                      height: 75,
                    ),
                  ),
                  Text(
                    'CineTrack',
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Sua jornada cinematográfica começa aqui',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: () {
                        Navigator.pushNamed(context, AuthRoutes.login);
                      },
                      child: const Text('Entrar'),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
