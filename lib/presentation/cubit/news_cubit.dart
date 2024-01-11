import 'package:bai5/domain/entities/news.dart';
import 'package:bai5/domain/usecases/get_news.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetNews getNews;

  NewsCubit({required this.getNews}) : super(const NewsState());

  void fetchNews() async {
    emit(state.copyWith(status: NewsStatus.loading));
    final news = await getNews();
    news.fold(
      (failure) => emit(state.copyWith(status: NewsStatus.failure)),
      (news) => emit(
        state.copyWith(
          status: NewsStatus.success,
          news: news,
        ),
      ),
    );
  }
}
