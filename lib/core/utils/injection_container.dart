import 'package:bai5/core/network/network_info.dart';
import 'package:bai5/data/datasources/news_remote_datasource.dart';
import 'package:bai5/data/repositories/news_repository_impl.dart';
import 'package:bai5/domain/repositories/news_repository.dart';
import 'package:bai5/domain/usecases/get_news.dart';
import 'package:bai5/presentation/cubit/news_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - News
  //Bloc
  sl.registerFactory(
    () => NewsCubit(
      getNews: sl(),
    ),
  );

  //Use cases
  sl.registerLazySingleton(() => GetNews(sl()));

  //Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(client: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectionChecker: sl(),
    ),
  );

  //! External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
