import 'package:cinetrack/features/movie/models/movie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieRepository {
  // recebe os dados do Firebase e transforma em uma lista de objeto
  Future<List<MovieModel>> getMovieList() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('movies')
        .get();
    return snapshot.docs.map((doc) => MovieModel.fromJson(doc.data())).toList();
    // o doc.data() retorna um Map<String, dynamic> 
    // o método fromJson do MovieModel recebe esse map transforma em um objeto
    // .toList() cria a lista
  }
}
