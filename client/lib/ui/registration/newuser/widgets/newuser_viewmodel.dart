import 'package:client/data/repositories/api_repository.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class NewUserViewmodel extends ChangeNotifier {
  NewUserViewmodel({required RegistrationRepository registrationRepository})
    : _registrationRepository = registrationRepository {
    registerUserData =
        Command1<void, (String username, String id, String code)>(
          _registerUserData,
        );
  }

  final RegistrationRepository _registrationRepository;

  late Command1 registerUserData;

  Future<Result<String>> _registerUserData(
    (String username, String id, String code) credentials,
  ) async {
    final (username, id, code) = credentials;
    final result = await _registrationRepository.setUserData(
      username: username,
      id: id,
      code: code,
    );
    return result;
  }
}
