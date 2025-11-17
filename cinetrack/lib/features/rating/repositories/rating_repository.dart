import 'dart:developer';

import 'package:cinetrack/features/rating/models/create_rating_model.dart';
import 'package:cinetrack/features/rating/models/rating_model.dart';
import 'package:cinetrack/features/rating/models/update_rating_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingRepository {
  late final FirebaseFirestore firestore;

  RatingRepository() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> createRating({required CreateRatingModel rating}) async {
    try {
      final docRef = await firestore.collection('ratings').add(rating.toMap());
      log('Rating created with ID: ${docRef.id}');
    } catch (e, stackTrace) {
      log('Error creating rating: ', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateRating({required UpdateRatingModel rating}) async {
    try {
      await firestore
          .collection('ratings')
          .doc(rating.id)
          .update(rating.toMap());
      log('Rating updated with ID: ${rating.id}');
    } catch (e, stackTrace) {
      log('Error updating rating: ', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<RatingModel>> getUserRatings({required String userId}) async {
    try {
      final snapshot = await firestore
          .collection('ratings')
          .where('userId', isEqualTo: userId)
          .get();

      if (snapshot.size <= 0) {
        return [];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final id = doc.id;
        data['id'] = id;
        return RatingModel.fromJson(data);
      }).toList();
    } catch (e) {
      log('Error fetching user ratings', error: e);
      rethrow;
    }
  }

  Future<List<RatingModel>> getAllUsersRatings() async {
    try {
      final snapshot = await firestore.collection('ratings').get();
      if (snapshot.size <= 0) {
        return [];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final id = doc.id;
        data['id'] = id;
        return RatingModel.fromJson(data);
      }).toList();
    } catch (e) {
      log('Error fetching users ratings: ', error: e);
      rethrow;
    }
  }

  Future<void> deleteRating({required String ratingId}) async {
    try {
      return firestore.collection('ratings').doc(ratingId).delete();
    } catch (error, stackTrace) {
      log('Error deleting rating', error: error, stackTrace: stackTrace);
    }
  }
}
