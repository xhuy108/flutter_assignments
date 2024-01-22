import 'package:bai5/core/errors/failure.dart';
import 'package:bai5/core/utils/usecase.dart';
import 'package:bai5/domain/repositories/news_repository.dart';
import 'package:dartz/dartz.dart';

class CacheFirstTime implements UseCaseWithoutParams<void> {
  final NewsRepository repository;

  const CacheFirstTime(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.cacheFirstTime();
  }
}
