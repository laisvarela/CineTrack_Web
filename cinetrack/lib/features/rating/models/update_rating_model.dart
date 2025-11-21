class UpdateRatingModel {
  final String id;
  final double rating;
  final String userId;
  final String movieId;
  final String? comment;

  UpdateRatingModel({
    required this.id,
    required this.rating,
    required this.userId,
    required this.movieId,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return {"rating": rating, "userId": userId, "movieId": movieId, "comment": comment};
  }
}
