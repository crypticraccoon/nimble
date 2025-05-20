import 'dart:convert';
import 'dart:io';
import 'package:client/data/services/models/user_data_response/user_data_response.dart';
import 'package:dio/dio.dart';

import '../../../utils/result.dart';
import '../models/login_response/login_response.dart';

const apiCallFailed = "Api call failed.";

class AuthApiClient {
  AuthApiClient({required String url}) : _url = url {
    _initDio();
  }

  final String _url;
  final Dio _clientFactory = Dio();

  void _initDio() {
    _clientFactory.interceptors.clear();
    _clientFactory.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          switch (error.type) {
            case DioExceptionType.unknown:
              handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: "Api call failed.",
                  type: error.type,
                  response: error.response,
                ),
              );
              break;

            case DioExceptionType.cancel:
              handler.reject(error);
              break;
            case DioExceptionType.connectionTimeout:
              handler.reject(error);

              break;
            case DioExceptionType.receiveTimeout:
              handler.reject(error);

              break;
            case DioExceptionType.sendTimeout:
              handler.reject(error);

              break;
            case DioExceptionType.badResponse:
              handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: error.error,
                  type: error.type,
                  response: error.response,
                ),
              );
              break;
            case DioExceptionType.connectionError:
              handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: "Failed to connect to server.",
                  type: error.type,
                  response: error.response,
                ),
              );
              break;

            default:
              handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: "Unknown error.",
                  type: error.type,
                  response: error.response,
                ),
              );
              break;
          }
        },
      ),
    );
  }

  Future<Result<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.post(
        "$_url/login",
        data: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        return Result.ok(LoginResponse.fromJson(jsonDecode(response.data)));
      } else {
        return Result.error(Exception(response.statusCode.toString()));
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future<Result<UserDataResponse>> getUserData({
    required String accessToken,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.get(
        "$_url/a/login",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        return Result.ok(UserDataResponse.fromJson(jsonDecode(response.data)));
      } else {
        return Result.error(Exception(response.statusCode.toString()));
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future logout({required String id}) async {
    final client = _clientFactory;
    try {
      final response = await client.post("$_url/a/logout");
      if (response.statusCode == 200) {
        return Result.ok(LoginResponse.fromJson(jsonDecode(response.data)));
      } else {
        return const Result.error(HttpException("Logout error"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<String>> sendPasswordRecoveryEmail({
    required String email,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.post(
        "$_url/recover",
        data: jsonEncode({"email": email}),
      );
      if (response.statusCode == 200) {
        return Result.ok(response.data.toString());
      } else {
        return const Result.error(
          HttpException("Failed to send password recovery email."),
        );
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future<Result<String>> updateRecoveryPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.put(
        "$_url/recover/update/$email/$code",
        data: jsonEncode({"password": password}),
      );
      if (response.statusCode == 200) {
        return Result.ok(response.data.toString());
      } else {
        return const Result.error(HttpException("Recover password failed."));
      }
    } on DioException catch (error) {
      print(error.response!.statusCode);
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future<Result<String>> registerUser({
    required String email,
    required String password,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.post(
        "$_url/register",
        data: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        return Result.ok(response.data.toString());
      } else {
        return Result.error(Exception(response.statusCode.toString()));
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future<Result<String>> registerUserData({
    required String username,
    required String id,
    required String code,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.put(
        "$_url/register/new/$id/$code",
        data: jsonEncode({"username": username}),
      );
      if (response.statusCode == 200) {
        return Result.ok(response.data.toString());
      } else {
        return Result.error(Exception(response.statusCode.toString()));
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }
}
