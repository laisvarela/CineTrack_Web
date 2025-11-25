import 'dart:async';

import 'package:cinetrack/features/rating/models/rating_model.dart';
import 'package:cinetrack/features/rating/repositories/rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return RatingRepository();
});

class RatingParams{
  final String? movieId;
  final String? userId;

  RatingParams({required this.movieId, required this.userId});

}
final ratingControllerProvider = AsyncNotifierProvider.autoDispose
    .family<RatingController, List<RatingModel>, RatingParams?>(RatingController.new);

class RatingController extends AutoDisposeFamilyAsyncNotifier<List<RatingModel>, RatingParams?> {
  @override
  FutureOr<List<RatingModel>> build(RatingParams? params) async{
    final repo = ref.watch(ratingRepositoryProvider);
    if(params!.movieId == null) return [];
    if(params.userId != null){
      return repo.getUserRatings(userId: params.userId!);
    }
    return repo.getAllUsersRatings(); 
  }
}
