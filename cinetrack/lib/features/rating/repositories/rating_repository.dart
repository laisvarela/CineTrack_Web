import 'dart:developer';

import 'package:cinetrack/features/rating/models/rating_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingRepository {
  Future<List<RatingModel>> getRatingList() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('ratings')
          .get();
      if (snapshot.size <= 0) {
        return [];
      }
      return snapshot.docs
          .map((doc) => RatingModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      log('Loading rating error: ', error: e);
      rethrow;
    }
  }
}
