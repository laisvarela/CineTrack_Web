import 'package:cinetrack/core/asset_images.dart';
import 'package:cinetrack/features/auth/routes/auth_routes.dart';
import 'package:cinetrack/features/user/repositories/user_repository.dart';
import 'package:cinetrack/theme/web_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userRole = UserRepository().userRole;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(AssetImages.mainIcon, width: 35, height: 35),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).popUntil((_) => false);
                  Navigator.pushNamed(context, AuthRoutes.login);
                },
                child: Text(
                  'Sair',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [
                  Color.fromARGB(255, 72, 49, 118),
                  Color.fromARGB(255, 18, 16, 58),
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  spacing: 20,
                  children: [
                    Text(
                      'Descubra filmes incríveis',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Avalie e explore o mundo do cinema',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(color: const Color.fromARGB(255, 214, 214, 214)),
                    ),
                    SizedBox(height: 1),
                    Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star),
                        Icon(Icons.star),
                        Icon(Icons.star),
                        Icon(Icons.star),
                        Icon(Icons.star),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Color.fromARGB(255, 83, 47, 130),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Color.fromARGB(255, 83, 47, 130),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
