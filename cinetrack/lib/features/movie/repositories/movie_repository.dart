import 'package:cinetrack/features/movie/models/movie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

// controller atualiza o estado de acordo com a resposta dos métodos implementados no repository

// repository faz as chamadas para API e esses negócios ai 

// service controla as regras de negócio e chama o repository e retorna para o controller

class MovieRepository {
  // recebe os dados do Firebase e transforma em uma lista de objeto
  Future<List<MovieModel>> getMovieList() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('movies')
          .get();
      if (snapshot.size <= 0) {
        return [];
      }
      return snapshot.docs
          .map((doc) => MovieModel.fromJson(doc.data()))
          .toList();
      // o doc.data() retorna um Map<String, dynamic>
      // o método fromJson do MovieModel recebe esse map transforma em um objeto
      // .toList() cria a lista
    } catch (e) {
      log("Erro em carregar filmes", error: e);
      rethrow;
    }
  }
}
