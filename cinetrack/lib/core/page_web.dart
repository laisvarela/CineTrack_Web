// cinetrack/lib/core/page_web.dart
import 'package:cinetrack/features/movie/models/movie_model.dart';
import 'package:cinetrack/features/user/models/user_model.dart';
import 'package:cinetrack/features/user/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinetrack/features/rating/controllers/create_rating_controller.dart';
import 'package:cinetrack/features/rating/controllers/update_rating_controller.dart';
import 'package:cinetrack/features/rating/controllers/detele_rating_controller.dart';
import 'package:cinetrack/features/user/controllers/user_controller.dart';
import 'package:cinetrack/features/movie/controllers/movie_controller.dart';

class PageWeb {
  final ProviderRef _ref;
  
  PageWeb(this._ref);
  
  // Getters para acessar os controllers de forma centralizada
  CreateRatingController get createRatingController => 
      _ref.read(createRatingProvider.notifier);
      
  UpdateRatingController get updateRatingController => 
      _ref.read(updateRatingControllerProvider.notifier);
      
  DeleteRatingController get deleteRatingController => 
      _ref.read(deleteRatingControllerProvider.notifier);
  
  // Providers de estado
  AsyncValue<void> get createRatingState => 
      _ref.watch(createRatingProvider);
      
  AsyncValue<void> get updateRatingState => 
      _ref.watch(updateRatingControllerProvider);
      
  AsyncValue<void> get deleteRatingState => 
      _ref.watch(deleteRatingControllerProvider);
  
  // User controllers
  UserRepository get userRepository => 
      _ref.read(userRepositoryProviver);
      
  AsyncValue<UserModel?> get userState => 
      _ref.watch(userControllerProvider);
      
  AsyncValue<String?> get userRoleState => 
      _ref.watch(userRoleProvider);
  
  // Movie controllers
  AsyncValue<List<MovieModel>> get moviesState => 
      _ref.watch(movieControllerProvider);
  
  // Métodos helper para invalidar providers
  void invalidateMovies() {
    _ref.invalidate(movieControllerProvider);
  }
  
  void invalidateUser() {
    _ref.invalidate(userControllerProvider);
    _ref.invalidate(userRoleProvider);
  }
}

// Provider para a PageWeb
final pageWebProvider = Provider<PageWeb>((ref) {
  return PageWeb(ref);
});