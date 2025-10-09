class MovieModel {
  final String titulo;
  final String ano;
  final String sinopse;
  final List<String> generos;
  final List<String> direcao;
  final String capa;

  MovieModel({
    required this.titulo,
    required this.ano,
    required this.sinopse,
    required this.generos,
    required this.direcao,
    required this.capa,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      titulo: json['titulo'],
      ano: json['ano'],
      sinopse: json['sinopse'],
      generos: json['genero'],
      direcao: json['direcao'],
      capa: json['capa'],
    );
  }
}
