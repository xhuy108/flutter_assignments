import 'package:bai5/core/errors/exception.dart';
import 'package:bai5/data/models/news_model.dart';
import 'package:bai5/domain/entities/news.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NewsLocalDataSource {
  const NewsLocalDataSource();

  Future<void> cacheFirstTime();
  Future<bool> isFirstTimer();
  Future<void> cacheNews(List<News> newsToCache);
  Future<List<NewsModel>> getNews();
  Future<void> clearCache();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  const NewsLocalDataSourceImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<List<NewsModel>> getNews() async {
    try {
      await Hive.openBox<News>('news');
      final newsBox = Hive.box<News>('news');
      final news = newsBox.values.toList();
      print(newsBox.values);
      // newsBox.clear();
      return news.map((e) => NewsModel.fromEntity(e)).toList();
    } on CacheException catch (e) {
      throw CacheException(e.message, e.statusCode);
    }
  }

  @override
  Future<void> cacheNews(List<News> newsToCache) async {
    try {
      await Hive.openBox<News>('news');
      final newsBox = Hive.box<News>('news');
      for (final news in newsToCache) {
        newsBox.put(news.id, news);
      }
    } on CacheException catch (e) {
      throw CacheException(e.message, e.statusCode);
    }
  }

  @override
  Future<void> cacheFirstTime() async {
    try {
      await _sharedPreferences.setBool('firstTime', false);
    } on CacheException catch (e) {
      throw CacheException(e.message, e.statusCode);
    }
  }

  @override
  Future<bool> isFirstTimer() async {
    try {
      return _sharedPreferences.getBool('firstTime') ?? true;
    } on CacheException catch (e) {
      throw CacheException(e.message, e.statusCode);
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await Hive.openBox<News>('news');
      final newsBox = Hive.box<News>('news');
      newsBox.clear();
    } on CacheException catch (e) {
      throw CacheException(e.message, e.statusCode);
    }
  }
}
