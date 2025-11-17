import 'dart:async';

import 'package:cinetrack/features/rating/repositories/rating_repository.dart';
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

  void deleteRating(String ratingId) async {
    try {
      state = AsyncValue.loading();
      await RatingRepository().deleteRating(ratingId: ratingId);
      state = AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
