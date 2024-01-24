import 'package:bai5/core/network/network_info.dart';
import 'package:bai5/data/datasources/news_local_datasource.dart';
import 'package:bai5/data/datasources/news_remote_datasource.dart';
import 'package:bai5/data/repositories/news_repository_impl.dart';
import 'package:bai5/domain/entities/news.dart';
import 'package:bai5/domain/repositories/news_repository.dart';
import 'package:bai5/domain/usecases/cache_first_time.dart';
import 'package:bai5/domain/usecases/cache_news.dart';
import 'package:bai5/domain/usecases/clear_cache.dart';
import 'package:bai5/domain/usecases/get_local_news.dart';
import 'package:bai5/domain/usecases/get_remote_news.dart';
import 'package:bai5/presentation/bloc/news_bloc.dart';

import 'package:bai5/presentation/cubit/news_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - News
  //Cubit
  sl.registerFactory(
    () => NewsCubit(
      getRemoteNews: sl(),
      getLocalNews: sl(),
      cacheNews: sl(),
      cacheFirstTime: sl(),
      sharedPreferences: sl(),
      clearCache: sl(),
    ),
  );

  //Bloc
  sl.registerFactory(
    () => NewsBloc(
      getRemoteNews: sl(),
      getLocalNews: sl(),
      cacheNews: sl(),
      cacheFirstTime: sl(),
      sharedPreferences: sl(),
      clearCache: sl(),
    ),
  );

  //Use cases
  sl.registerLazySingleton(() => GetRemoteNews(sl()));
  sl.registerLazySingleton(() => GetLocalNews(sl()));
  sl.registerLazySingleton(() => CacheNews(sl()));
  sl.registerLazySingleton(() => CacheFirstTime(sl()));
  sl.registerLazySingleton(() => ClearCache(sl()));

  //Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  //Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(sl()),
  );

  Hive.registerAdapter(NewsAdapter());
  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectionChecker: sl(),
    ),
  );

  //! External

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnection());
  final preferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => preferences);
}
