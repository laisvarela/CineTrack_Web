import 'package:cinetrack/features/rating/controllers/detele_rating_controller.dart';
import 'package:cinetrack/features/user/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:cinetrack/features/rating/repositories/rating_repository.dart';
import 'package:cinetrack/features/rating/models/rating_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinetrack/features/auth/repositories/auth_repository.dart';
import 'package:cinetrack/features/rating/widgets/rating_editor_widget.dart';

class RatingsWidget extends ConsumerStatefulWidget {
  final String movieId;
  const RatingsWidget({super.key, required this.movieId});

  @override
  ConsumerState<RatingsWidget> createState() => _RatingsWidgetState();
}

class _RatingsWidgetState extends ConsumerState<RatingsWidget> {
  @override
  Widget build(BuildContext context) {
    // userId obtido síncronamente via AuthRepository
    final currentUser = AuthRepository().getCurrentUser();
    final String? userId = currentUser?.uid;

    // busca avaliações e role do usuário
    final combined = Future.wait([
      RatingRepository().getRatingsForMovie(movieId: widget.movieId),
      ref.read(userRepositoryProviver).getUserRole(),
    ]);

    return FutureBuilder<List<Object?>>(
      future: combined,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }
        final results = snapshot.data ?? [];
        final ratings = (results.isNotEmpty
            ? results[0] as List<RatingModel>
            : <RatingModel>[]);
        final userRole =
            (results.length > 1 ? results[1] as String? : null)
                ?.toLowerCase() ??
            '';

        // se não há avaliações: mostra mensagem + botão para adicionar (função vazia)
        if (ratings.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nenhuma avaliação ainda.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                if (userId != null)
                  ElevatedButton(
                    onPressed: () async {
                      await showRatingEditorDialog(
                        context: context,
                        ref: ref,
                        movieId: widget.movieId,
                        userId: userId,
                        rating: null,
                      );
                      setState(() {}); // refaz a FutureBuilder
                    },
                    child: const Text('Adicionar avaliação'),
                  ),
              ],
            ),
          );
        }

        // existe pelo menos uma avaliação
        final bool hasUserRating =
            userId != null && ratings.any((r) => r.userId == userId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // se o usuário não é admin e não tem avaliação, mostra botão para adicionar
            if (userId != null && userRole != 'admin' && !hasUserRating)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    await showRatingEditorDialog(
                      context: context,
                      ref: ref,
                      movieId: widget.movieId,
                      userId: userId,
                      rating: null,
                    );
                    if (mounted) setState(() {}); // refaz a FutureBuilder
                  },
                  child: const Text('Adicionar avaliação'),
                ),
              ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ratings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final r = ratings[i];
                final isOwn = userId != null && r.userId == userId;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, size: 18),
                            const SizedBox(width: 8),

                            Expanded(
                              child: FutureBuilder<String?>(
                                future: r.userId == userId
                                    ? ref
                                          .read(userRepositoryProviver)
                                          .getUserName()
                                    : ref
                                          .read(userRepositoryProviver)
                                          .getUserNameById(r.userId),
                                builder: (ctx, snap) {
                                  if (snap.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      'Carregando...',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }
                                  final name = snap.data ?? 'Usuário';
                                  return Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              r.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // admin pode remover qualquer avaliação
                            if (userRole == 'admin') ...[
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                onPressed: () async {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Confirmar'),
                                      content: const Text(
                                        'Deseja excluir essa avaliação?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: const Text('Não'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: const Text('Sim'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (ok == true) {
                                    try {
                                      await ref
                                          .read(
                                            deleteRatingControllerProvider
                                                .notifier,
                                          )
                                          .deleteRating(r.id);
                                      if (mounted)
                                        setState(() {}); // atualiza lista
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Avaliação removida'),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text('Erro: $e')),
                                        );
                                      }
                                    }
                                  }
                                },
                                tooltip: 'Remover avaliação',
                              ),
                            ] else if (isOwn) ...[
                              // usuário comum: só editar/remover na própria avaliação
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () async {
                                  await showRatingEditorDialog(
                                    context: context,
                                    ref: ref,
                                    movieId: widget.movieId,
                                    userId: userId,
                                    rating: r,
                                  );
                                  setState(() {});
                                },
                                tooltip: 'Editar avaliação',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                onPressed: () async {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Confirmar'),
                                      content: const Text(
                                        'Deseja excluir essa avaliação?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: const Text('Não'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: const Text('Sim'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (ok == true) {
                                    try {
                                      await ref
                                          .read(
                                            deleteRatingControllerProvider
                                                .notifier,
                                          )
                                          .deleteRating(r.id);
                                      if (mounted)
                                        setState(() {}); // atualiza lista
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Avaliação removida'),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text('Erro: $e')),
                                        );
                                      }
                                    }
                                  }
                                },
                                tooltip: 'Remover avaliação',
                              ),
                            ],
                          ],
                        ),
                        if (r.comment != null && r.comment!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(r.comment!),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
