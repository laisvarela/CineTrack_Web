class MovieModel {
  final String title;
  final String year;
  final String sinopse;
  final String genres;
  final String directors;
  final String cover;
  final String id;

  MovieModel({
    required this.title,
    required this.year,
    required this.sinopse,
    required this.genres,
    required this.directors,
    required this.cover,
    required this.id,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return MovieModel(
      id: id ?? '',
      title: json['titulo'],
      year: json['ano'],
      sinopse: json['sinopse'],
      genres: json['genero'],
      directors: json['direcao'],
      cover: json['capa'],
    );
  }
}
