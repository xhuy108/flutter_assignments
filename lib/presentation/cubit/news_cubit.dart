import 'dart:ui';

import 'package:bai5/domain/entities/news.dart';
import 'package:bai5/domain/usecases/cache_first_time.dart';
import 'package:bai5/domain/usecases/cache_news.dart';
import 'package:bai5/domain/usecases/clear_cache.dart';
import 'package:bai5/domain/usecases/get_local_news.dart';
import 'package:bai5/domain/usecases/get_remote_news.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetRemoteNews getRemoteNews;
  final GetLocalNews getLocalNews;
  final CacheNews cacheNews;
  final CacheFirstTime cacheFirstTime;
  final SharedPreferences sharedPreferences;
  final ClearCache clearCache;

  NewsCubit({
    required this.getRemoteNews,
    required this.getLocalNews,
    required this.cacheNews,
    required this.cacheFirstTime,
    required this.sharedPreferences,
    required this.clearCache,
  }) : super(const NewsState());

  void fetchNews(int page) async {
    if (state.hasReachedMax) return;
    final isFirstTime = sharedPreferences.getBool('firstTime');
    if (isFirstTime == null || isFirstTime) {
      if (page == 1) emit(state.copyWith(status: NewsStatus.loading));
      fetchRemoteNews(page);
    } else {
      print('not first time');

      if (page == 1) {
        fetchLocalNews();
      }
      print('local news');
      print(state.news.length);

      fetchRemoteNews(page);

      print('remote news');
      print(state.news.length);
    }
  }

  void cachingNews(List<News> news) async {
    await cacheNews(news);
  }

  void cachingFirstTime() async {
    await cacheFirstTime();
  }

  void fetchLocalNews() async {
    final localNews = await getLocalNews();
    localNews.fold(
        (failure) => emit(
              state.copyWith(
                status: NewsStatus.failure,
                error: failure.message,
              ),
            ), (news) {
      emit(state.copyWith(
        status: NewsStatus.success,
        news: news,
        hasReachedMax: true,
      ));
    });
  }

  void fetchRemoteNews(int page) async {
    final isFirstTime = sharedPreferences.getBool('firstTime');
    final remoteNews = await getRemoteNews(page);
    print(remoteNews);

    remoteNews.fold((failure) {
      if (isFirstTime == null || isFirstTime) {
        emit(
          state.copyWith(
            status: NewsStatus.failure,
            error: failure.message,
          ),
        );
      } else {
        emit(
          state.copyWith(hasReachedMax: true),
        );
      }
    }, (news) {
      if (news.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        if (page == 1) {
          emit(state.copyWith(
            status: NewsStatus.success,
            news: news,
            hasReachedMax: false,
          ));
          clearCache();
        } else {
          emit(state.copyWith(
            status: NewsStatus.success,
            news: [...state.news, ...news],
            hasReachedMax: false,
          ));
        }
        cachingNews(news);
      }
    });
  }
}
