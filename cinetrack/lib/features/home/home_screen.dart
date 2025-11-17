import 'package:carousel_slider/carousel_slider.dart';
import 'package:cinetrack/core/asset_images.dart';
import 'package:cinetrack/features/auth/routes/auth_routes.dart';
import 'package:cinetrack/features/movie/controllers/movie_controller.dart';
import 'package:cinetrack/features/movie/movie_screen.dart';
import 'package:cinetrack/features/user/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userControllerProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(child: Image.asset(AssetImages.mainIcon)),
        ),
        title: user.when(
          data: (user) => Text("Olá, ${user?.name ?? ''}"),
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) => Text('Olá'),
        ),
        titleTextStyle: Theme.of(context).textTheme.bodyLarge,
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.of(context).popUntil((_) => false);
              Navigator.pushNamed(context, AuthRoutes.login);
            },
            child: Text('Sair', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          const double cardWidth = 260.0;
          final double availableWidth = constraints.maxWidth;
          final double viewportFraction = (cardWidth / availableWidth).clamp(
            0.08,
            1.0,
          );
          return SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: constraints.maxHeight,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 72, 49, 118),
                        Color.fromARGB(255, 18, 16, 58),
                      ],
                    ),
                  ),
                ),

                // conteúdo em cima do background
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 240,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  Text(
                                    'Descubra filmes incríveis',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displayLarge,
                                  ),
                                  Text(
                                    'Avalie e explore o mundo do cinema',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
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
                        SizedBox(
                          height: 380,
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
                            child: Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        _carouselController.previousPage(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.ease,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: CarouselSlider.builder(
                                    itemCount: ref
                                        .watch(movieControllerProvider)
                                        .maybeWhen(
                                          data: (movies) => movies.length,
                                          orElse: () => 0,
                                        ),
                                    carouselController: _carouselController,
                                    itemBuilder: (context, index, realIndex) {
                                      final movieState = ref.watch(
                                        movieControllerProvider,
                                      );
                                      return movieState.when(
                                        error: (error, stackTrace) {
                                          return Center(
                                            child: Text(
                                              'Erro ao carregar filmes',
                                            ),
                                          );
                                        },
                                        loading: () => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        data: (movies) {
                                          if (movies.isEmpty) {
                                            return Center(
                                              child: Text(
                                                'Nenhum filme encontrado',
                                              ),
                                            );
                                          }
                                          final movie = movies[index];
                                          return Center(
                                            child: SizedBox(
                                              height: 380,
                                              width: 260,
                                              key: ValueKey(movie.id),
                                              child: Card(
                                                child: MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: InkWell(
                                                    onTap: () {
                                                      final movieId = movie.id;
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              MovieScreen(
                                                                movieId:
                                                                    movieId,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: SizedBox(
                                                            height: 180,
                                                            width: double
                                                                .maxFinite,
                                                            child: Image.network(
                                                              movie.capa,
                                                              fit: BoxFit
                                                                  .contain,
                                                              alignment:
                                                                  Alignment
                                                                      .topCenter,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 10,
                                                                right: 10,
                                                              ),
                                                          child: Column(
                                                            spacing: 8,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                movie.generos,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                              Text(
                                                                movie.titulo,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                movie.ano,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 350,
                                      viewportFraction: viewportFraction,
                                      enlargeCenterPage: false,
                                      enableInfiniteScroll: true,
                                      scrollPhysics:
                                          const NeverScrollableScrollPhysics(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        _carouselController.nextPage(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.ease,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 100,
                          color: const Color.fromARGB(255, 18, 16, 58),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
