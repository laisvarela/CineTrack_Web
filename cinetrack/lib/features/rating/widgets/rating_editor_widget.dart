import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinetrack/features/movie/widgets/star_rating.dart';
import 'package:cinetrack/features/rating/models/create_rating_model.dart';
import 'package:cinetrack/features/rating/models/update_rating_model.dart';
import 'package:cinetrack/features/rating/models/rating_model.dart';
import 'package:cinetrack/features/rating/controllers/create_rating_controller.dart';
import 'package:cinetrack/features/rating/controllers/update_rating_controller.dart';

/// Abre um dialog para criar/editar uma avaliação.
/// - se [rating] == null => cria nova avaliação (usará [`CreateRatingModel`](cinetrack/lib/features/rating/models/create_rating_model.dart))
/// - senão => atualiza via [`UpdateRatingModel`](cinetrack/lib/features/rating/models/update_rating_model.dart)
Future<void> showRatingEditorDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String movieId,
  required String userId,
  RatingModel? rating,
}) {
  final initialRating = rating?.rating ?? 0.0;
  final commentController = TextEditingController(text: rating?.comment ?? '');
  double ratingValue = initialRating;

  return showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(
          rating == null ? 'Adicionar avaliação' : 'Editar avaliação',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StarRating(
                initialRating: ratingValue,
                onRatingChanged: (newRating) {
                  setState(() {
                    ratingValue = newRating;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Comentário (opcional)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final comment = commentController.text.trim();
              try {
                if (rating == null) {
                  final createModel = CreateRatingModel(
                    userId: userId,
                    movieId: movieId,
                    rating: ratingValue,
                    comment: comment.isEmpty ? null : comment,
                  );
                  if (context.mounted) {
                    await ref
                        .read(createRatingProvider.notifier)
                        .create(createModel);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                } else {
                  final updateModel = UpdateRatingModel(
                    id: rating.id,
                    userId: userId,
                    movieId: movieId,
                    rating: ratingValue,
                    comment: comment.isEmpty ? null : comment,
                  );
                  if (!context.mounted) return;
                  ref
                      .read(updateRatingControllerProvider.notifier)
                      .updateRating(updateModel);
                }
                // usa o context recebido pela função externa e valida mounted
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Erro: $e')));
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    ),
  );
}
