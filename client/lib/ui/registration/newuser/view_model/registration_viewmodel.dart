import 'package:client/data/repositories/auth_repository.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class RegistrationViewmodel extends ChangeNotifier {
  RegistrationViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    registerUser = Command1<void, (String email, String password)>(
      _registerUser,
    );
  }

  final AuthRepository _authRepository;

  late Command1 registerUser;

  Future<Result<String>> _registerUser(
    (String email, String password) credentials,
  ) async {
    final (email, password) = credentials;
    final result = await _authRepository.registerUser(
      email: email,
      password: password,
    );

    return result;
  }
}
