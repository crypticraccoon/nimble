import 'package:client/data/repositories/api_repository.dart';
import 'package:client/data/services/models/todo_response/todo_response.dart';
import 'package:client/utils/command.dart';
import 'package:client/utils/result.dart';
import 'package:flutter/material.dart';

class CreateTodoViewModel extends ChangeNotifier {
  CreateTodoViewModel({required TodoRepository todoRepository})
    : _todoRepository = todoRepository {
    createTodo = Command1<void, (String title, String body, String deadline)>(
      _createTodo,
    );
  }

  final TodoRepository _todoRepository;

  late Command1 createTodo;

  Future<Result<TodoResponse>> _createTodo(
    (String title, String body, String deadline) credentials,
  ) async {
    final (String title, String body, String deadline) = credentials;

    final result = await _todoRepository.createTodo(
      body: body,
      title: title,
      deadline: deadline,
    );
    switch (result) {
      case Ok<TodoResponse>():
        return Result.ok(result.value);
      case Error<TodoResponse>():
        return Result.error(result.error);
    }
  }
}
