import 'package:flutter/material.dart';
import 'package:cinetrack/features/rating/repositories/rating_repository.dart';
import 'package:cinetrack/features/rating/models/rating_model.dart';

class RatingsWidget extends StatelessWidget {
  final String movieId;
  const RatingsWidget({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RatingModel>>(
      future: RatingRepository().getAllUsersRatings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }
        final ratings = snapshot.data ?? [];
        if (ratings.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Nenhuma avaliação ainda.', textAlign: TextAlign.center),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ratings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final r = ratings[i];
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
                        Expanded(child: Text(r.userName, style: const TextStyle(fontWeight: FontWeight.w600))),
                        const SizedBox(width: 8),
                        Text(r.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
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
        );
      },
    );
  }
}