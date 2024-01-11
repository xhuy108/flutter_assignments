import 'package:bai5/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UseCaseWithParams<Type, Params> {
  const UseCaseWithParams();

  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseWithoutParams<Type> {
  const UseCaseWithoutParams();

  Future<Either<Failure, Type>> call();
}
