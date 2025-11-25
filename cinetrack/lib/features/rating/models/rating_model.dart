class RatingModel {
  final String id;
  final double rating;
  final String userId;
  final String movieId;
  final String? comment;

  RatingModel({
    required this.id,
    required this.rating,
    required this.userId,
    required this.movieId,
    this.comment,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    // safety parsing: rating can be int or double; userName may be missing
    final ratingValue = json['rating'] is num
        ? (json['rating'] as num).toDouble()
        : double.tryParse(json['rating']?.toString() ?? '') ?? 0.0;

    return RatingModel(
      id: json['id'],
      rating: ratingValue,
      userId: json['userId'] ?? '',
      movieId: json['movieId'] ?? '',
      comment: json['comment'],
    );
  }
}
