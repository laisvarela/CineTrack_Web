import 'package:cinetrack/features/user/models/user_model.dart';
import 'package:cinetrack/features/user/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProviver = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userControllerProvider = FutureProvider.autoDispose<UserModel?>((ref) {
  return ref.watch(userRepositoryProviver).getUser();
});
