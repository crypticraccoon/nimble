import 'package:client/data/repositories/api_repository.dart';
import 'package:flutter/material.dart';
import '../../../../utils/result.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({
    required UserRepository userRepository,
    required AuthRepository authRepository,
  }) : _userRepository = userRepository,
       _authRepository = authRepository;

  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  Future<Result<String?>> logout() async {
    final result = await _authRepository.logout();
    switch (result) {
      case Ok<String?>():
        print(result.value);
      case Error<String?>():
        print(result.error.toString());
    }

    return Result.ok(null);
    //switch (result) {
    //case Ok<String>():
    //return
    //}
    //if (result is Error<String>) {
    //_log.warning('Settings failed! ${result.error}');
    //}
    //return result;
  }
}
