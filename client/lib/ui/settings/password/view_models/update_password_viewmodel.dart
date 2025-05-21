import 'package:client/data/repositories/api_repository.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class UpdatePasswordViewModel extends ChangeNotifier {
  UpdatePasswordViewModel({required UserRepository userRepository})
    : _userRepository = userRepository {
    updatePassword = Command1<void, (String password, String oldPassword)>(
      _updatePassword,
    );
  }

  final UserRepository _userRepository;

  late Command1 updatePassword;

  Future<Result<String?>> _updatePassword(
    (String password, String oldPassword) credentials,
  ) async {
    final (password, oldPassword) = credentials;

    final result = await _userRepository.updatePassword(
      newPassword: password,
      password: oldPassword,
    );
    switch (result) {
      case Ok<String?>():
        return Result.ok(result.value);
      case Error<String?>():
        return Result.error(result.error);
    }
  }
}
