import 'dart:async';

import 'package:cinetrack/features/rating/models/update_rating_model.dart';
import 'package:cinetrack/features/rating/services/rating_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateRatingControllerProvider =
    AsyncNotifierProvider.autoDispose<UpdateRatingController, void>(
      UpdateRatingController.new,
    );

class UpdateRatingController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  void updateRating(UpdateRatingModel rating) async {
    try {
      state = AsyncValue.loading();
      await RatingService().updateRatingAndUpdateMovie(rating);
      state = AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
