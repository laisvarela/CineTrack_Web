class RatingModel {
  final String id;
  final String userId;
  final String movieId;
  final String? comment;

  RatingModel({
    required this.id,
    required this.userId,
    required this.movieId,
    this.comment,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      userId: json['userId'],
      movieId: json['movieId'],
      comment: json['comment'],
    );
  }
}
