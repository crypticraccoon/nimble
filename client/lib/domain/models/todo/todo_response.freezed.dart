// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoResponse {

 String get id; String get user_id; String get title; String get body; DateTime get deadline; DateTime get created_at; DateTime get completed_at; bool get is_completed;
/// Create a copy of TodoResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoResponseCopyWith<TodoResponse> get copyWith => _$TodoResponseCopyWithImpl<TodoResponse>(this as TodoResponse, _$identity);

  /// Serializes this TodoResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.user_id, user_id) || other.user_id == user_id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.completed_at, completed_at) || other.completed_at == completed_at)&&(identical(other.is_completed, is_completed) || other.is_completed == is_completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,user_id,title,body,deadline,created_at,completed_at,is_completed);

@override
String toString() {
  return 'TodoResponse(id: $id, user_id: $user_id, title: $title, body: $body, deadline: $deadline, created_at: $created_at, completed_at: $completed_at, is_completed: $is_completed)';
}


}

/// @nodoc
abstract mixin class $TodoResponseCopyWith<$Res>  {
  factory $TodoResponseCopyWith(TodoResponse value, $Res Function(TodoResponse) _then) = _$TodoResponseCopyWithImpl;
@useResult
$Res call({
 String id, String user_id, String title, String body, DateTime deadline, DateTime created_at, DateTime completed_at, bool is_completed
});




}
/// @nodoc
class _$TodoResponseCopyWithImpl<$Res>
    implements $TodoResponseCopyWith<$Res> {
  _$TodoResponseCopyWithImpl(this._self, this._then);

  final TodoResponse _self;
  final $Res Function(TodoResponse) _then;

/// Create a copy of TodoResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? user_id = null,Object? title = null,Object? body = null,Object? deadline = null,Object? created_at = null,Object? completed_at = null,Object? is_completed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,user_id: null == user_id ? _self.user_id : user_id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,completed_at: null == completed_at ? _self.completed_at : completed_at // ignore: cast_nullable_to_non_nullable
as DateTime,is_completed: null == is_completed ? _self.is_completed : is_completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TodoResponse implements TodoResponse {
  const _TodoResponse({required this.id, required this.user_id, required this.title, required this.body, required this.deadline, required this.created_at, required this.completed_at, required this.is_completed});
  factory _TodoResponse.fromJson(Map<String, dynamic> json) => _$TodoResponseFromJson(json);

@override final  String id;
@override final  String user_id;
@override final  String title;
@override final  String body;
@override final  DateTime deadline;
@override final  DateTime created_at;
@override final  DateTime completed_at;
@override final  bool is_completed;

/// Create a copy of TodoResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoResponseCopyWith<_TodoResponse> get copyWith => __$TodoResponseCopyWithImpl<_TodoResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodoResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodoResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.user_id, user_id) || other.user_id == user_id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.completed_at, completed_at) || other.completed_at == completed_at)&&(identical(other.is_completed, is_completed) || other.is_completed == is_completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,user_id,title,body,deadline,created_at,completed_at,is_completed);

@override
String toString() {
  return 'TodoResponse(id: $id, user_id: $user_id, title: $title, body: $body, deadline: $deadline, created_at: $created_at, completed_at: $completed_at, is_completed: $is_completed)';
}


}

/// @nodoc
abstract mixin class _$TodoResponseCopyWith<$Res> implements $TodoResponseCopyWith<$Res> {
  factory _$TodoResponseCopyWith(_TodoResponse value, $Res Function(_TodoResponse) _then) = __$TodoResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String user_id, String title, String body, DateTime deadline, DateTime created_at, DateTime completed_at, bool is_completed
});




}
/// @nodoc
class __$TodoResponseCopyWithImpl<$Res>
    implements _$TodoResponseCopyWith<$Res> {
  __$TodoResponseCopyWithImpl(this._self, this._then);

  final _TodoResponse _self;
  final $Res Function(_TodoResponse) _then;

/// Create a copy of TodoResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? user_id = null,Object? title = null,Object? body = null,Object? deadline = null,Object? created_at = null,Object? completed_at = null,Object? is_completed = null,}) {
  return _then(_TodoResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,user_id: null == user_id ? _self.user_id : user_id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,completed_at: null == completed_at ? _self.completed_at : completed_at // ignore: cast_nullable_to_non_nullable
as DateTime,is_completed: null == is_completed ? _self.is_completed : is_completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
