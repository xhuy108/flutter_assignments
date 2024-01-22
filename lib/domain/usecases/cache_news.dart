import 'package:bai5/core/errors/failure.dart';
import 'package:bai5/core/utils/usecase.dart';
import 'package:bai5/domain/entities/news.dart';
import 'package:bai5/domain/repositories/news_repository.dart';
import 'package:dartz/dartz.dart';

class CacheNews implements UseCaseWithParams<void, List<News>> {
  final NewsRepository repository;

  const CacheNews(this.repository);

  @override
  Future<Either<Failure, void>> call(List<News> news) async {
    return await repository.cacheNews(news);
  }
}
