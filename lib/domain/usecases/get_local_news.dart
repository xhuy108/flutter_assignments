import 'package:bai5/core/errors/failure.dart';
import 'package:bai5/domain/entities/news.dart';
import 'package:bai5/domain/repositories/news_repository.dart';
import 'package:bai5/core/utils/usecase.dart';
import 'package:dartz/dartz.dart';

class GetLocalNews implements UseCaseWithoutParams<List<News>> {
  final NewsRepository repository;

  const GetLocalNews(this.repository);

  @override
  Future<Either<Failure, List<News>>> call() async {
    return await repository.getLocalNews();
  }
}
