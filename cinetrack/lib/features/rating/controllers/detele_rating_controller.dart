import 'dart:async';

import 'package:cinetrack/features/rating/services/rating_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteRatingControllerProvider =
    AsyncNotifierProvider.autoDispose<DeleteRatingController, void>(
      DeleteRatingController.new,
    );

class DeleteRatingController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  /// Retorna Future para que o chamador possa await e tratar o resultado.
  Future<void> deleteRating(String ratingId) async {
    // apenas delega ao service — não manipula `state` aqui.
    await RatingService().deleteRatingAndUpdateMovie(ratingId);
  }
}
