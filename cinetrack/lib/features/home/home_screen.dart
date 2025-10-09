import 'package:cinetrack/core/asset_images.dart';
import 'package:cinetrack/features/auth/routes/auth_routes.dart';
import 'package:cinetrack/features/user/repositories/user_repository.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
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
                            children: [
                              Text(
                                'Descubra filmes incríveis',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              Text(
                                'Avalie e explore o mundo do cinema',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(color: const Color.fromARGB(255, 214, 214, 214)),
                              ),
                              SizedBox(height: 8),
                              Row(
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
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 18, 16, 58),
                              Color.fromARGB(255, 38, 36, 71),
                            ],
                          ),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 100,
                      color: Color.fromARGB(255, 18, 16, 58),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
