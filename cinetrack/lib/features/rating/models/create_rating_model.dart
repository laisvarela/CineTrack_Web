class CreateRatingModel {
  final String userId;
  final String movieId;
  final String? comment;
  final double rating;

  CreateRatingModel({
    required this.userId,
    required this.movieId,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return {"rating": rating, "userId": userId, "movieId": movieId, "comment": comment};
  }
}
