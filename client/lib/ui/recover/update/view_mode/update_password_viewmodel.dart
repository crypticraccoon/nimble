import 'package:client/data/repositories/auth_repository.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class UpdatePasswordViewmodel extends ChangeNotifier {
  UpdatePasswordViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    updateRecoveryPassword =
        Command1<void, (String email, String code, String password)>(
          _updateRecoveryPassword,
        );
  }

  final AuthRepository _authRepository;

  late Command1 updateRecoveryPassword;

  Future<Result<String>> _updateRecoveryPassword(
    (String email, String code, String password) credentials,
  ) async {
    final (email, code, password) = credentials;
    final result = await _authRepository.updateRecoveryPassword(
      email: email,
      password: password,
      code: code,
    );
    return result;
  }
}
