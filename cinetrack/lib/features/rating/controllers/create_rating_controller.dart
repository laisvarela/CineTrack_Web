import 'dart:async';

import 'package:cinetrack/features/rating/models/create_rating_model.dart';
import 'package:cinetrack/features/rating/repositories/rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createRatingProvider =
    AsyncNotifierProvider.autoDispose<CreateRatingController, void>(
      CreateRatingController.new,
    );

class CreateRatingController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<dynamic> build() {
    return null;
  }

  void create(CreateRatingModel rating) async {
    try {
      state = AsyncValue.loading();
      await RatingRepository().createRating(rating: rating);
      // como o provider é do tipo null, o success é sinalizado com null também
      state = AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
