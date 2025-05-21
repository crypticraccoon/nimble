import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_stats_response.freezed.dart';

part 'todo_stats_response.g.dart';

/// TodoStatsResponse model.
@freezed
abstract class TodoStatsResponse with _$TodoStatsResponse {
  const factory TodoStatsResponse({
    required int complete,
    required int in_progress,
  }) = _TodoStatsResponse;

  factory TodoStatsResponse.fromJson(Map<String, Object?> json) =>
      _$TodoStatsResponseFromJson(json);
}
