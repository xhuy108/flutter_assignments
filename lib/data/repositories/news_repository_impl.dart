import 'package:bai5/core/errors/exception.dart';
import 'package:bai5/core/errors/failure.dart';
import 'package:bai5/core/network/network_info.dart';
import 'package:bai5/data/datasources/news_remote_datasource.dart';
import 'package:bai5/data/models/news_model.dart';
import 'package:bai5/domain/repositories/news_repository.dart';
import 'package:dartz/dartz.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NewsModel>>> getNews(int page) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteNews = await remoteDataSource.getNews(page);

        return Right(remoteNews);
      } else {
        return Left(
          ServerFailure.fromException(
            const ServerException(
              'No internet',
              500,
            ),
          ),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
