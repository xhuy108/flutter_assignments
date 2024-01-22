import 'package:bai5/core/errors/failure.dart';
import 'package:bai5/domain/entities/news.dart';
import 'package:dartz/dartz.dart';

abstract class NewsRepository {
  Future<Either<Failure, void>> cacheFirstTime();
  Future<Either<Failure, List<News>>> getRemoteNews(int page);
  Future<Either<Failure, List<News>>> getLocalNews();
  Future<Either<Failure, void>> cacheNews(List<News> newsToCache);
  Future<Either<Failure, void>> clearCache();
}
