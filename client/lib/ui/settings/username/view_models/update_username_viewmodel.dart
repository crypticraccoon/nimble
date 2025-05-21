import 'package:client/data/repositories/api_repository.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class UpdateUsernameViewmodel extends ChangeNotifier {
  UpdateUsernameViewmodel({required UserRepository userRepository})
    : _userRepository = userRepository {
    updateUsername = Command1<void, (String email,)>(_updateUsername);
  }

  final UserRepository _userRepository;

  late Command1 updateUsername;

  Future<Result<String?>> _updateUsername(
    (String username,) credentials,
  ) async {
    final (username,) = credentials;

    final result = await _userRepository.updateUsername(username: username);
    switch (result) {
      case Ok<String?>():
        return Result.ok(result.value);
      case Error<String?>():
        return Result.error(result.error);
    }
  }
}
