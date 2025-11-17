class CreateRatingModel {
  final String userId;
  final String movieId;
  final String? comment;

  CreateRatingModel({
    required this.userId,
    required this.movieId,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return {"userId": userId, "movieId": movieId, "comment": comment};
  }
}
