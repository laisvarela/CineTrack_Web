import 'package:cinetrack/core/asset_images.dart';
import 'package:cinetrack/features/movie/controllers/movie_controller.dart';
import 'package:cinetrack/features/movie/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  final String? movieId;
  const MovieScreen({super.key, this.movieId});

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(movieControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(child: Image.asset(AssetImages.mainIcon)),
        ),
        title: Text(
          'CineTrack',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height -
                kToolbarHeight -
                MediaQuery.of(context).padding.top,
          ),
          child: Container(
            width: double.infinity,
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
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Avalie e explore o mundo do cinema',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: const Color.fromARGB(255, 214, 214, 214),
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
                    SizedBox(height: 20),
                    Center(
                      child: LayoutBuilder(
                        builder: (context, inner) {
                          final maxWidth = inner.maxWidth > 1100
                              ? 1000.0
                              : inner.maxWidth * 0.95;
                          return Container(
                            width: maxWidth,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: movies.when(
                              data: (movieList) {
                                MovieModel? movieSelected;
                                if (widget.movieId != null) {
                                  movieSelected = movieList.firstWhere(
                                    (m) => m.id == widget.movieId,
                                  );
                                } else {
                                  movieSelected = movieList.isNotEmpty
                                      ? movieList.first
                                      : null;
                                }
                                if (movieSelected == null) {
                                  return const Center(
                                    child: Text('Filme não encontrado'),
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Card(
                                          clipBehavior: Clip.hardEdge,
                                          child: Image.network(
                                            movieSelected.capa,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Card(
                                            elevation: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Título: ${movieSelected.titulo}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text(
                                                    'Gênero: ${movieSelected.generos}',
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    'Direção: ${movieSelected.direcao}',
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    'Ano: ${movieSelected.ano}',
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text(
                                                    'Sinopse:',
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.titleSmall,
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    movieSelected.sinopse,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20),
                                    Text(
                                      'Avaliações',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 12),

                                    const Text(
                                      'Nenhuma avaliação por enquanto.',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                );
                              },
                              loading: () => const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              error: (e, st) => Center(child: Text('Erro: $e')),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
