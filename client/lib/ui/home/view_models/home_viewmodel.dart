import 'package:client/data/repositories/auth_repository.dart';
import 'package:client/data/services/shared_prefrences_service.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class HomeViewmodel extends ChangeNotifier {
  HomeViewmodel({
    required SharedPreferencesService sharedPrefrences,
    required AuthRepository authRepository,
  }) : _authRepository = authRepository,
       _sharedPreferences = sharedPrefrences;

  final AuthRepository _authRepository;
  final SharedPreferencesService _sharedPreferences;

  Future<Result<String>> _getUsername(
    (String username, String id, String code) credentials,
  ) async {
    final username = await _sharedPreferences.fetchUserUsername();
    switch (username) {
      case Ok<String?>():
        return Result.ok(username.toString());
      default:
        return Result.error(Exception("Missing username"));
    }
  }
}
