import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/result.dart';

// NOTE: Move tokens to flutter_secured_storage instead
class SharedPreferencesService {
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshTokenKey';
  static const _id = "id";
  static const _username = "username";
  static const _email = "email";

  Future<Result<String?>> fetchAccessToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_accessTokenKey));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> fetchRefreshToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_refreshTokenKey));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> saveTokens(
    String? accessToken,
    String? refreshToken,
  ) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (accessToken == null || refreshToken == null) {
        await sharedPreferences.remove(_accessTokenKey);
        await sharedPreferences.remove(_refreshTokenKey);

        await sharedPreferences.remove(_id);
        await sharedPreferences.remove(_username);
        await sharedPreferences.remove(_email);
      } else {
        await sharedPreferences.setString(_accessTokenKey, accessToken);
        await sharedPreferences.setString(_refreshTokenKey, refreshToken);
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> saveUserData({
    required String id,
    required String email,
    required String username,
  }) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(_id, id);
      await sharedPreferences.setString(_email, email);
      await sharedPreferences.setString(_username, username);

      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> fetchUserId() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_id));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> fetchUserEmail() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_email));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> fetchUserUsername() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_username));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
