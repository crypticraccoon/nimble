import 'package:client/data/repositories/api_repository.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class UpdateEmailViewmodel extends ChangeNotifier {
  UpdateEmailViewmodel({required UserRepository userRepository})
    : _userRepository = userRepository {
    updateEmail = Command1<void, (String email,)>(_updateEmail);
  }

  final UserRepository _userRepository;

  late Command1 updateEmail;

  Future<Result<String?>> _updateEmail((String email,) credentials) async {
    final (email,) = credentials;

    final result = await _userRepository.updateUserEmail(email: email);
    switch (result) {
      case Ok<String?>():
        return Result.ok(result.value);
      case Error<String?>():
        return Result.error(result.error);
    }
  }
}
