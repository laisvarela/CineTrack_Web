import 'package:flutter/material.dart';
import 'package:cinetrack/features/rating/repositories/rating_repository.dart';
import 'package:cinetrack/features/rating/models/rating_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinetrack/features/auth/repositories/auth_repository.dart';
import 'package:cinetrack/features/rating/widgets/rating_editor_widget.dart';
import 'package:cinetrack/core/page_web.dart';

class RatingsWidget extends ConsumerStatefulWidget {
  final String movieId;
  const RatingsWidget({super.key, required this.movieId});

  @override
  ConsumerState<RatingsWidget> createState() => _RatingsWidgetState();
}

class _RatingsWidgetState extends ConsumerState<RatingsWidget> {
  List<RatingModel> _cachedRatings = [];
  bool _isLoading = true;
  String? _error;
  late PageWeb _pageWeb;

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pageWeb = ref.read(pageWebProvider);
  }

  Future<void> _loadRatings() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final ratings = await RatingRepository().getRatingsForMovie(
        movieId: widget.movieId,
      );
      if (mounted) {
        setState(() {
          _cachedRatings = ratings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthRepository().getCurrentUser();
    final String? userId = currentUser?.uid;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Erro: $_error'));
    }

    return _pageWeb.userRoleState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Erro: $e')),
      data: (role) {
        // se não há avaliações: mostra mensagem  botão para adicionar
        if (_cachedRatings.isEmpty) {
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
                if (userId != null && role != 'admin')
                  ElevatedButton(
                    onPressed: () async {
                      await showRatingEditorDialog(
                        context: context,
                        ref: ref,
                        movieId: widget.movieId,
                        userId: userId,
                        rating: null,
                        pageWeb: _pageWeb,
                      );
                      // setState(() {});
                      if (mounted) _loadRatings(); // recarrega dados
                    },
                    child: const Text('Adicionar avaliação'),
                  ),
              ],
            ),
          );
        }

        // existe pelo menos uma avaliação
        final bool hasUserRating =
            userId != null && _cachedRatings.any((r) => r.userId == userId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // se o usuário não é admin e não tem avaliação, mostra botão para adicionar
            if (userId != null && role != 'admin' && !hasUserRating)
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
                      pageWeb: _pageWeb,
                    );
                    if (mounted) _loadRatings(); // recarrega dados
                  },
                  child: const Text('Adicionar avaliação'),
                ),
              ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cachedRatings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                // Proteção contra index out of bounds
                if (index >= _cachedRatings.length) {
                  return const SizedBox.shrink();
                }
                final r = _cachedRatings[index];
                // Calcule isOwn para ESTA avaliação específica
                final bool isOwn = userId != null && r.userId == userId;

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
                              child: _UserNameWidget(
                                userId: r.userId,
                                currentUserId: userId,
                                pageWeb: _pageWeb,
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
                            if (role == 'admin') ...[
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
                                      await _pageWeb.deleteRatingController
                                          .deleteRating(r.id);
                                      if (mounted) {
                                        _loadRatings(); // recarrega dados
                                      }
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
                                    pageWeb: _pageWeb, // passe PageWeb
                                  );
                                  if (mounted)
                                    _loadRatings(); // recarrega dados
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
                                      await _pageWeb.deleteRatingController
                                          .deleteRating(r.id);
                                      if (mounted) {
                                        _loadRatings(); // recarrega dados
                                      }
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

/// Widget separado para mostrar nomes de usuário
class _UserNameWidget extends ConsumerWidget {
  final String userId;
  final String? currentUserId;
  final PageWeb pageWeb;

  const _UserNameWidget({
    required this.userId,
    required this.currentUserId,
    required this.pageWeb,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (userId == currentUserId) {
      // Nome do usuário logado via PageWeb
      return pageWeb.userState.when(
        loading: () => const Text(
          'Carregando...',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        error: (e, st) => const Text(
          'Usuário',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        data: (user) => Text(
          user?.name ?? 'Usuário',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    } else {
      // Nome de outro usuário - busca por ID
      return FutureBuilder<String?>(
        future: pageWeb.userRepository.getUserNameById(userId),
        builder: (ctx, snap) => Text(
          snap.data ?? 'Usuário',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }
  }
}
