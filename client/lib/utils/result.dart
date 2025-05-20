//import 'package:dio/dio.dart';

sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok._;

  const factory Result.error(Exception error) = Error._;
  //const factory Result.errorDio(DioException error) = ErrorDio._;
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

final class Error<T> extends Result<T> {
  const Error._(this.error);

  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}

//final class ErrorDio<T> extends Result<T> {
  //const ErrorDio._(this.errorDio);

  //final DioException errorDio;

  //@override
  //String toString() => 'Result<$T>.error($errorDio)';
//}
