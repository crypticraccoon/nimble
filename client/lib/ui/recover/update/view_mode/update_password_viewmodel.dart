import 'package:client/data/repositories/api_repository.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class UpdatePasswordViewmodel extends ChangeNotifier {
  UpdatePasswordViewmodel({required RecoveryRepository recoveryRepository})
    : _recoveryRepository = recoveryRepository {
    updateRecoveryPassword =
        Command1<void, (String email, String code, String password)>(
          _updateRecoveryPassword,
        );
  }
  final RecoveryRepository _recoveryRepository;

  late Command1 updateRecoveryPassword;

  Future<Result<String>> _updateRecoveryPassword(
    (String email, String code, String password) credentials,
  ) async {
    final (email, code, password) = credentials;
    final result = await _recoveryRepository.updatePassword(
      email: email,
      password: password,
      code: code,
    );
    return result;
  }
}
