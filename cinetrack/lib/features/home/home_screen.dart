import 'package:carousel_slider/carousel_slider.dart';
import 'package:cinetrack/core/asset_images.dart';
import 'package:cinetrack/features/auth/routes/auth_routes.dart';
import 'package:cinetrack/features/movie/controllers/movie_controller.dart';
import 'package:cinetrack/features/user/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String userRole = UserRepository().userRole;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movieState = ref.watch(movieControllerProvider);
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
          final topHeight = 250.0;
          final footerHeight = 100.0;
          final minChildSize =
              ((constraints.maxHeight - topHeight - footerHeight).clamp(
                0.15,
                0.85,
              ));

          return Stack(
            children: [
              Column(
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
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(
                                    color: const Color.fromARGB(
                                      255,
                                      214,
                                      214,
                                      214,
                                    ),
                                  ),
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
                      height: footerHeight,
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
                      child: CarouselSlider.builder(
                        itemCount: ref
                            .watch(movieControllerProvider)
                            .maybeWhen(
                              data: (movies) => movies.length,
                              orElse: () => 0,
                            ),
                        itemBuilder: (context, index, realIndex) {
                          final movieState = ref.watch(movieControllerProvider);
                          return movieState.when(
                            error: (error, stackTrace) {
                              return Center(
                                child: Text('Erro ao carregar filmes'),
                              );
                            },
                            loading: () =>
                                Center(child: CircularProgressIndicator()),
                            data: (movies) {
                              if (movies.isEmpty) {
                                return Center(
                                  child: Text('Nenhum filme encontrado'),
                                );
                              }
                              final movie = movies[index];
                              return Center(child: SizedBox(height: 300, width: 250, child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),));
                            },
                          );
                        },
                        options: CarouselOptions(autoPlay: true, ),
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
            ],
          );
        },
      ),
    );
  }
}
