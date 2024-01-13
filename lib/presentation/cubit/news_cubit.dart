import 'package:bai5/domain/entities/news.dart';
import 'package:bai5/domain/usecases/get_news.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetNews getNews;

  NewsCubit({required this.getNews}) : super(const NewsState());

  void fetchNews(int page) async {
    if (state.hasReachedMax) return;
    if (page == 1) emit(state.copyWith(status: NewsStatus.loading));
    final news = await getNews(page);

    news.fold(
        (failure) => emit(
              state.copyWith(
                status: NewsStatus.failure,
                error: failure.message,
              ),
            ), (news) {
      if (news.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        if (page == 1) {
          emit(state.copyWith(
            status: NewsStatus.success,
            news: news,
            hasReachedMax: false,
          ));
        } else {
          emit(state.copyWith(
            status: NewsStatus.success,
            news: List.of(state.news)..addAll(news),
            hasReachedMax: false,
          ));
        }
      }
    });
  }
}
