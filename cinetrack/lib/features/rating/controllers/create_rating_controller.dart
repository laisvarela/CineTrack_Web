import 'dart:async';

import 'package:cinetrack/features/rating/models/create_rating_model.dart';
import 'package:cinetrack/features/rating/services/rating_service.dart';
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

  Future<void> create(CreateRatingModel rating) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await RatingService().createRatingAndUpdateMovie(rating);
    });
  }
}
