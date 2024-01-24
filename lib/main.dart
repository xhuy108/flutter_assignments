import 'package:bai5/core/network/network_info.dart';
import 'package:bai5/data/datasources/news_local_datasource.dart';
import 'package:bai5/data/datasources/news_remote_datasource.dart';
import 'package:bai5/data/repositories/news_repository_impl.dart';
import 'package:bai5/domain/entities/news.dart';
import 'package:bai5/domain/usecases/cache_first_time.dart';
import 'package:bai5/domain/usecases/cache_news.dart';
import 'package:bai5/domain/usecases/clear_cache.dart';
import 'package:bai5/domain/usecases/get_local_news.dart';
import 'package:bai5/domain/usecases/get_remote_news.dart';
import 'package:bai5/presentation/cubit/news_cubit.dart';
import 'package:bai5/presentation/pages/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(NewsAdapter());

  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final repository = NewsRepositoryImpl(
      networkInfo: NetworkInfoImpl(connectionChecker: InternetConnection()),
      remoteDataSource: NewsRemoteDataSourceImpl(client: Dio()),
      localDataSource: NewsLocalDataSourceImpl(sharedPreferences),
    );

    return RepositoryProvider(
      create: (context) => repository,
      child: BlocProvider(
        create: (context) => NewsCubit(
          getRemoteNews: GetRemoteNews(repository),
          getLocalNews: GetLocalNews(repository),
          cacheNews: CacheNews(repository),
          cacheFirstTime: CacheFirstTime(repository),
          sharedPreferences: sharedPreferences,
          clearCache: ClearCache(repository),
        )
          ..fetchNews(1)
          ..cachingFirstTime(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(),
        ),
      ),
    );
  }
}
