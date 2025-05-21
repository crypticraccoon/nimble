import 'dart:convert';
import 'dart:io';
import 'package:client/data/services/models/todo_response/todo_response.dart';
import 'package:client/data/services/models/todo_stats_response/todo_stats_response.dart';
import 'package:client/data/services/models/user_data_response/user_data_response.dart';
import 'package:dio/dio.dart';

import '../../../utils/result.dart';
import '../models/login_response/login_response.dart';

const apiCallFailed = "Api call failed.";

class ApiClient {
  ApiClient({required String url}) : _url = url {
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

  //Auth
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

  Future<Result<String>> logout() async {
    final client = _clientFactory;
    try {
      final response = await client.post("$_url/logout");
      if (response.statusCode == 200) {
        return Result.ok(response.data.toString());
      } else {
        return const Result.error(HttpException("Logout error"));
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future<Result<LoginResponse>> refresh({
    required String accessToken,
    required String refreshToken,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.post(
        "$_url/refresh",
        data: jsonEncode({
          "access_token": accessToken,
          "refresh_token": refreshToken,
        }),
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

  //Recovery
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
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  //Registration
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

  // User
  Future<Result<UserDataResponse>> getUserData({
    required String accessToken,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.get(
        "$_url/a/user",
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

  // User Update Endpoints
  Future<Result<String>> updateUsername({
    required String accessToken,
    required String username,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.patch(
        "$_url/a/user/update/username",
        data: jsonEncode({"username": username}),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
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

  Future<Result<String>> updatePassword({
    required String accessToken,
    required String password,
    required String newPassword,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.patch(
        "$_url/a/user/update/password",
        data: jsonEncode({"password": password, "new_password": newPassword}),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
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

  Future<Result<String>> updateEmail({
    required String accessToken,
    required String email,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.patch(
        "$_url/a/user/update/email",
        data: jsonEncode({"email": email}),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
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

  //Todo

  Future<Result<TodoResponse>> createTodo({
    required String accessToken,
    required String title,
    required String body,
    required String deadline,
  }) async {
    final client = _clientFactory;

    try {
      final response = await client.post(
        "$_url/a/todo/create",
        data: jsonEncode({"title": title, "body": body, "deadline": deadline}),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        return Result.ok(TodoResponse.fromJson(jsonDecode(response.data)));
      } else {
        return Result.error(Exception(response.statusCode.toString()));
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future<Result<TodoResponse>> getTodo({
    required String accessToken,
    required String id,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.get(
        "$_url/a/todo/$id",

        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        return Result.ok(TodoResponse.fromJson(jsonDecode(response.data)));
      } else {
        return Result.error(Exception(response.statusCode.toString()));
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future<Result<List<TodoResponse>>> getTodosByDate({
    required String accessToken,
    required String date,
    required int size,
    required int page,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.get(
        "$_url/a/todo/$date/$size/$page",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> todoData = jsonDecode(response.data);

        final List<TodoResponse> todos =
            todoData
                .map(
                  (json) => TodoResponse.fromJson(json as Map<String, dynamic>),
                )
                .toList();

        return Result.ok(todos);
      } else {
        return Result.error(Exception(response.statusCode.toString()));
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future<Result<List<TodoResponse>>> getCompletedTodos({
    required String accessToken,
    required int size,
    required int page,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.get(
        "$_url/a/todo/completed/$size/$page",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> todoData = response.data;
        final List<TodoResponse> todos =
            todoData
                .map((json) => TodoResponse.fromJson(jsonDecode(json)))
                .toList();

        return Result.ok(todos);
      } else {
        return Result.error(Exception(response.statusCode.toString()));
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future<Result<TodoStatsResponse>> getTodoStats({
    required String accessToken,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.get(
        "$_url/a/todo/stats",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        return Result.ok(TodoStatsResponse.fromJson(jsonDecode(response.data)));
      } else {
        return Result.error(Exception(response.statusCode.toString()));
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future<Result<String>> completeTodo({
    required String accessToken,
    required String id,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.patch(
        "$_url/a/todo/complete/$id",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        return Result.ok((response.data.toString()));
      } else {
        return Result.error(Exception(response.statusCode.toString()));
      }
    } on DioException catch (error) {
      return Result.error(Exception(error.response.toString()));
    } catch (e) {
      return Result.error(Exception(apiCallFailed));
    }
  }

  Future<Result<String>> updateTodo({
    required String accessToken,
    required String id,
    required String title,
    required String body,
    required DateTime deadline,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.put(
        "$_url/a/update",
        data: jsonEncode({
          "id": id,
          "title": title,
          "body": body,
          "deadline": deadline,
        }),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
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

  Future<Result<String>> deleteTodo({
    required String accessToken,
    required String id,
  }) async {
    final client = _clientFactory;
    try {
      final response = await client.delete(
        "$_url/a/todo/delete/$id",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        return Result.ok((response.data.toString()));
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

