import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_response.freezed.dart';

part 'todo_response.g.dart';

/// TodoResponse model.
@freezed
abstract class TodoResponse with _$TodoResponse {
  const factory TodoResponse({
    required String id,
    required String user_id,
    required String title,
    required String body,
    required DateTime deadline,
    required DateTime created_at,
    required DateTime completed_at,
    required bool is_completed,
  }) = _TodoResponse;

  factory TodoResponse.fromJson(Map<String, Object?> json) =>
      _$TodoResponseFromJson(json);
}
