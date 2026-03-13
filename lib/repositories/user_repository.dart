import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';

class UserRepository {
  final Box<UserProfile> _box;

  UserRepository(this._box);

  UserProfile? getUserProfile() {
    return _box.get('current_user');
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _box.put('current_user', profile);
  }

  bool hasProfile() {
    return _box.containsKey('current_user');
  }
}
