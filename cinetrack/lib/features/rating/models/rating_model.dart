class RatingModel {
  final String id;
  final double rating;
  final String userId;
  final String userName;
  final String movieId;
  final String? comment;

  RatingModel({
    required this.id,
    required this.rating,
    required this.userId,
    required this.userName,
    required this.movieId,
    this.comment,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      rating: json['rating'],
      userId: json['userId'],
      userName: json['userName'],
      movieId: json['movieId'],
      comment: json['comment'],
    );
  }
}
