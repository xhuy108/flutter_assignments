import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  const ServerException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheException extends Equatable implements Exception {
  const CacheException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}
