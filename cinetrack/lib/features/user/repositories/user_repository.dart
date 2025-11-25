import 'dart:developer';
import 'package:cinetrack/features/user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  UserModel? _user;

  Future<UserModel?> getUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return null;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final data = doc.data();
      if (data == null) return null;
      _user = UserModel.fromJson(data);
      return _user;
    } catch (e) {
      log("Error on getUser: $e");
      return null;
    }
  }

  Future<String?> getUserRole() async {
    final u = await getUser();
    log('UserRole repository: ${u?.role}');
    return u?.role;
  }

  Future<String?> getUserName() async {
    final u = await getUser();
    return u?.name;
  }
}
