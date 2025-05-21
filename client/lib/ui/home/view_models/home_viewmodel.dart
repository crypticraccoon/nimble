import 'package:client/data/repositories/api_repository.dart';
import 'package:client/data/services/shared_prefrences_service.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required SharedPreferencesService sharedPrefrences,
    required UserRepository userRepository,
    required TodoRepository todoRepository,
  }) : _userRepository = userRepository,
       _todoRepository = todoRepository,
       _sharedPreferences = sharedPrefrences {
    getUsername = Command0(_getUsername);
    loadUserData = Command0(_loadUserData);

    print("from intL: $username");
  }

  final UserRepository _userRepository;
  final TodoRepository _todoRepository;
  final SharedPreferencesService _sharedPreferences;

  late Command0 getUsername;
  late Command0 loadUserData;

  String? _username;
  String? get username => _username;

  Future<Result<void>> _loadUserData() async {
    final result = await _userRepository.getUserData();
    return result;
  }

  Future<Result<String?>> _getUsername() async {
    print("fetching username from shjared");
    final result = await _sharedPreferences.fetchUserUsername();
    switch (result) {
      case Ok<String?>():
        print(result.value);
        _username = result.value;
        return Result.ok(result.value);
      case Error<String?>():
        return Result.error(Exception("Missing username"));
    }
  }
}
