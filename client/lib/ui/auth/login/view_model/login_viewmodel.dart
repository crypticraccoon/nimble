import 'package:client/data/repositories/api_repository.dart';
import 'package:client/utils/command.dart';
import 'package:flutter/material.dart';
import '../../../../utils/result.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    login = Command1<void, (String email, String password)>(_login);
  }

  final AuthRepository _authRepository;

  late Command1 login;

  Future<Result<String?>> _login((String, String) credentials) async {
    final (email, password) = credentials;
    final result = await _authRepository.login(
      email: email,
      password: password,
    );
    return result;
  }
}
