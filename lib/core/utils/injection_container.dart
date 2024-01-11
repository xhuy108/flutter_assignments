import 'package:bai5/data/datasources/news_remote_datasource.dart';
import 'package:bai5/data/repositories/news_repository_impl.dart';
import 'package:bai5/domain/repositories/news_repository.dart';
import 'package:bai5/domain/usecases/get_news.dart';
import 'package:bai5/presentation/cubit/news_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
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
    ),
  );

  //Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(client: sl()),
  );

  // //Core
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  sl.registerLazySingleton(() => Dio());
  // sl.registerLazySingleton(() => DataConnectionChecker());
}
