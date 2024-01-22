import 'package:bai5/core/errors/exception.dart';
import 'package:bai5/core/errors/failure.dart';
import 'package:bai5/core/network/network_info.dart';
import 'package:bai5/data/datasources/news_local_datasource.dart';
import 'package:bai5/data/datasources/news_remote_datasource.dart';
import 'package:bai5/data/models/news_model.dart';
import 'package:bai5/domain/entities/news.dart';
import 'package:bai5/domain/repositories/news_repository.dart';
import 'package:dartz/dartz.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NetworkInfo networkInfo;
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  const NewsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<NewsModel>>> getRemoteNews(int page) async {
    try {
      final isInternetConnected = await networkInfo.isConnected;
      print(isInternetConnected);
      if (isInternetConnected) {
        final remoteNews = await remoteDataSource.getNews(page);

        return Right(remoteNews);
      } else {
        return const Left(
          ServerFailure(
            message: 'No internet connection',
            statusCode: 400,
          ),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> cacheNews(List<News> newsToCache) async {
    try {
      await localDataSource.cacheNews(newsToCache);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> cacheFirstTime() async {
    try {
      await localDataSource.cacheFirstTime();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<News>>> getLocalNews() async {
    try {
      final localNews = await localDataSource.getNews();

      return Right(localNews);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCache();

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }
}
