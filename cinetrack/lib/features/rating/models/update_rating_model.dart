class UpdateRatingModel {
  final String id;
  final String userId;
  final String movieId;
  final String? comment;

  UpdateRatingModel({
    required this.id,
    required this.userId,
    required this.movieId,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return {"userId": userId, "movieId": movieId, "comment": comment};
  }
}
