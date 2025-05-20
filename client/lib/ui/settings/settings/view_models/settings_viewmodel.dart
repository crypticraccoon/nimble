import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:client/data/repositories/auth_repository.dart';
import '../../../../utils/result.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;
  final _log = Logger('SettingsViewModel');

  Future<Result<void>> logout() async {
    try {
      final result = await _authRepository.logout();
      if (result is Error<void>) {
        _log.warning('Settings failed! ${result.error}');
      }
      return result;
    } catch (e) {
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }
}
