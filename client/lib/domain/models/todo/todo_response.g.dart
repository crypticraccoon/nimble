// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoResponse _$TodoResponseFromJson(Map<String, dynamic> json) =>
    _TodoResponse(
      id: json['id'] as String,
      user_id: json['user_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      created_at: DateTime.parse(json['created_at'] as String),
      completed_at: DateTime.parse(json['completed_at'] as String),
      is_completed: json['is_completed'] as bool,
    );

Map<String, dynamic> _$TodoResponseToJson(_TodoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'title': instance.title,
      'body': instance.body,
      'deadline': instance.deadline.toIso8601String(),
      'created_at': instance.created_at.toIso8601String(),
      'completed_at': instance.completed_at.toIso8601String(),
      'is_completed': instance.is_completed,
    };
