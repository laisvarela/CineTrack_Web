import 'package:cinetrack/features/movie/models/movie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

// controller atualiza o estado de acordo com a resposta dos métodos implementados no repository

// repository faz as chamadas para API e esses negócios ai

class MovieRepository {
  late final FirebaseFirestore firebase;

  MovieRepository() {
    firebase = FirebaseFirestore.instance;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getMovieSnapshot(
    String movieId,
  ) {
    return firebase.collection('movies').doc(movieId).get();
  }

  Future<void> updateAggregates(
    String movieId,
    double ratingAverage,
    int ratingCount,
  ) {
    final movieRef = firebase.collection('movies').doc(movieId);
    return movieRef.update({
      'ratingAverage': ratingAverage,
      'ratingCount': ratingCount,
    });
  }

  // recebe os dados do Firebase e transforma em uma lista de objeto
  Future<List<MovieModel>> getMovieList() async {
    try {
      final snapshot = await firebase.collection('movies').get();
      if (snapshot.size <= 0) {
        return [];
      }
      return snapshot.docs
          .map((doc) => MovieModel.fromJson(doc.data(), id: doc.id))
          .toList();
      // o doc.data() retorna um Map<String, dynamic>
      // o método fromJson do MovieModel recebe esse map transforma em um objeto
      // .toList() cria a lista
    } catch (e) {
      log("Loading movies error: ", error: e);
      rethrow;
    }
  }
}
