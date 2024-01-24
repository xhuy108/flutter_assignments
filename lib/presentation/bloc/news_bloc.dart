import 'package:bai5/domain/entities/news.dart';
import 'package:bai5/domain/usecases/cache_first_time.dart';
import 'package:bai5/domain/usecases/cache_news.dart';
import 'package:bai5/domain/usecases/clear_cache.dart';
import 'package:bai5/domain/usecases/get_local_news.dart';
import 'package:bai5/domain/usecases/get_remote_news.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_transform/stream_transform.dart';

part 'news_event.dart';
part 'news_state.dart';

const throttleDuration = Duration(seconds: 1);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, _) => events.throttle(duration);
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetRemoteNews getRemoteNews;
  final GetLocalNews getLocalNews;
  final CacheNews cacheNews;
  final CacheFirstTime cacheFirstTime;
  final SharedPreferences sharedPreferences;
  final ClearCache clearCache;

  NewsBloc({
    required this.getRemoteNews,
    required this.getLocalNews,
    required this.cacheNews,
    required this.cacheFirstTime,
    required this.sharedPreferences,
    required this.clearCache,
  }) : super(const NewsState()) {
    on<NewsFetched>(
      fetchNews,
      // transformer: throttleDroppable(throttleDuration),
    );
    on<FirstTimeCached>(cachingFirstTime);
  }

  void fetchNews(NewsFetched event, Emitter<NewsState> emit) async {
    if (state.hasReachedMax) return;
    final isFirstTime = sharedPreferences.getBool('firstTime');
    if (isFirstTime == null || isFirstTime) {
      if (event.page == 1) emit(state.copyWith(status: NewsStatus.loading));
      final remoteNews = await getRemoteNews(event.page);
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
          if (event.page == 1) {
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
    } else {
      print('not first time');

      if (event.page == 1) {
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
      print('local news');
      print(state.news.length);

      // fetchRemoteNews(event.page, emit);

      final remoteNews = await getRemoteNews(event.page);
      print(remoteNews);

      remoteNews.fold((failure) {
        emit(
          state.copyWith(hasReachedMax: true),
        );
      }, (news) {
        if (news.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          if (event.page == 1) {
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

      print('remote news');
      print(state.news.length);
    }
  }

  void fetchLocalNews(Emitter<NewsState> emit) async {
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

  void fetchRemoteNews(int page, Emitter<NewsState> emit) async {
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

  void cachingNews(List<News> news) async {
    await cacheNews(news);
  }

  void cachingFirstTime(FirstTimeCached event, Emitter<NewsState> emit) async {
    await cacheFirstTime();
  }
}
