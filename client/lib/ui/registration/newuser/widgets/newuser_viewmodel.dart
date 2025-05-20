import 'package:client/data/repositories/auth_repository.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class NewUserViewmodel extends ChangeNotifier {
  NewUserViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    registerUserData =
        Command1<void, (String username, String id, String code)>(
          _registerUserData,
        );
  }

  final AuthRepository _authRepository;

  late Command1 registerUserData;

  Future<Result<String>> _registerUserData(
    (String username, String id, String code) credentials,
  ) async {
    final (username, id, code) = credentials;
    final result = await _authRepository.registerUserData(
      username: username,
      id: id,
      code: code,
    );
    return result;
  }
}
