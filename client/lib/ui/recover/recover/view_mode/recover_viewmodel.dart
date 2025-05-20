import 'package:client/data/repositories/auth_repository.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class RecoverViewmodel extends ChangeNotifier {
  RecoverViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    sendPasswordRecoveryEmail = Command1<void, (String email,)>(
      _sendPasswordRecoveryEmail,
    );
  }

  final AuthRepository _authRepository;

  late Command1 sendPasswordRecoveryEmail;

  Future<Result<String>> _sendPasswordRecoveryEmail(
    (String,) credentials,
  ) async {
    final (String email,) = credentials;
    final result = await _authRepository.sendPasswordRecoveryEmail(
      email: email,
    );
    return result;
  }
}
