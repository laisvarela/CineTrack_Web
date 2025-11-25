import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinetrack/features/auth/repositories/auth_repository.dart';
import 'package:cinetrack/features/rating/repositories/rating_repository.dart';
import 'package:cinetrack/features/rating/models/rating_model.dart';
import 'package:cinetrack/features/movie/repositories/movie_repository.dart';
import 'package:cinetrack/features/movie/models/movie_model.dart';
import 'package:cinetrack/features/rating/widgets/rating_editor_widget.dart';
import 'package:cinetrack/features/rating/controllers/detele_rating_controller.dart';
import 'package:cinetrack/core/asset_images.dart';
import 'package:cinetrack/features/movie/controllers/movie_controller.dart';
import 'package:cinetrack/features/auth/routes/auth_routes.dart';

class UserRatingsScreen extends ConsumerStatefulWidget {
  const UserRatingsScreen({super.key});

  @override
  ConsumerState<UserRatingsScreen> createState() => _UserRatingsScreenState();
}

class _UserRatingsScreenState extends ConsumerState<UserRatingsScreen> {
  List<Map<String, dynamic>> items = [];
  bool loading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    final currentUser = AuthRepository().getCurrentUser();
    userId = currentUser?.uid;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      items = [];
    });
    try {
      if (userId == null) return;
      final ratings = await RatingRepository().getUserRatings(userId: userId!);
      final repo = MovieRepository();
      final List<Map<String, dynamic>> tmp = [];
      for (final r in ratings) {
        MovieModel? movie;
        try {
          final snap = await repo.getMovieSnapshot(r.movieId);
          if (snap.exists) {
            movie = MovieModel.fromJson(snap.data() as Map<String, dynamic>, id: snap.id);
          }
        } catch (_) {}
        tmp.add({'rating': r, 'movie': movie});
      }
      setState(() {
        items = tmp;
      });
    } catch (_) {
      // ignore
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _onDelete(String ratingId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('Deseja excluir essa avaliação?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Não')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sim')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(deleteRatingControllerProvider.notifier).deleteRating(ratingId);
      if (mounted) {
        await _load();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Avaliação removida')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 72, 49, 118),
              Color.fromARGB(255, 18, 16, 58),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar customizado
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () {
                            ref.invalidate(movieControllerProvider);
                            Navigator.of(context).pop();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 8),
                          child: ClipOval(child: Image.asset(AssetImages.mainIcon, width: 36, height: 36)),
                        ),
                        Text('Minhas avaliações', style: Theme.of(context).textTheme.displayMedium),
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        await AuthRepository().logout();
                        if (!context.mounted) return;
                        Navigator.of(context).popUntil((_) => false);
                        Navigator.pushNamed(context, AuthRoutes.login);
                      },
                      child: Text('Sair', style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
              // conteúdo central
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Card(
                      elevation: 4,
                      color: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: loading
                            ? const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()))
                            : items.isEmpty
                                ? const SizedBox(
                                    height: 200,
                                    child: Center(child: Text('Você não escreveu nenhuma avaliação ainda.')),
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: items.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                                    itemBuilder: (context, i) {
                                      final RatingModel r = items[i]['rating'] as RatingModel;
                                      final MovieModel? m = items[i]['movie'] as MovieModel?;
                                      return Card(
                                        child: ListTile(
                                          leading: m != null
                                              ? Image.network(m.cover, width: 56, fit: BoxFit.cover)
                                              : const Icon(Icons.movie),
                                          title: Text(m?.title ?? 'Filme'),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Nota: ${r.rating.toStringAsFixed(1)}'),
                                              if (r.comment != null && r.comment!.isNotEmpty) Text(r.comment!),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () async {
                                                  await showRatingEditorDialog(
                                                    context: context,
                                                    ref: ref,
                                                    movieId: r.movieId,
                                                    userId: userId!,
                                                    rating: r,
                                                  );
                                                  if (mounted) await _load();
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () async => _onDelete(r.id),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}