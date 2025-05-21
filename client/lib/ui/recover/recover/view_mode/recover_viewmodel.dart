import 'package:client/data/repositories/api_repository.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class RecoveryViewmodel extends ChangeNotifier {
  RecoveryViewmodel({required RecoveryRepository recoveryRepository})
    : _recoveryRepository = recoveryRepository {
    sendPasswordRecoveryEmail = Command1<void, (String email,)>(
      _sendPasswordRecoveryEmail,
    );
  }

  final RecoveryRepository _recoveryRepository;

  late Command1 sendPasswordRecoveryEmail;

  Future<Result<String>> _sendPasswordRecoveryEmail(
    (String,) credentials,
  ) async {
    final (String email,) = credentials;
    final result = await _recoveryRepository.sendRecoveryEmail(email: email);
    return result;
  }
}
