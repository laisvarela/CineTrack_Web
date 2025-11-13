class MovieModel {
  final String titulo;
  final String ano;
  final String sinopse;
  final String generos;
  final String direcao;
  final String capa;
  final String id;

  MovieModel({
    required this.titulo,
    required this.ano,
    required this.sinopse,
    required this.generos,
    required this.direcao,
    required this.capa,
    required this.id,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return MovieModel(
      id: id??'',
      titulo: json['titulo'],
      ano: json['ano'],
      sinopse: json['sinopse'],
      generos: json['genero'],
      direcao: json['direcao'],
      capa: json['capa'],
    );
  }
}
