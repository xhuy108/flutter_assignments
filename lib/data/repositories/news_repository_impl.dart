import 'package:bai5/core/errors/exception.dart';
import 'package:bai5/core/errors/failure.dart';
import 'package:bai5/data/datasources/news_remote_datasource.dart';
import 'package:bai5/data/models/news_model.dart';
import 'package:bai5/domain/repositories/news_repository.dart';
import 'package:dartz/dartz.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  const NewsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<NewsModel>>> getNews(int page) async {
    try {
      final remoteNews = await remoteDataSource.getNews(page);

      return Right(remoteNews);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
