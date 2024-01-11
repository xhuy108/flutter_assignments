part of 'news_cubit.dart';

enum NewsStatus { initial, loading, success, failure }

final class NewsState extends Equatable {
  const NewsState({
    this.status = NewsStatus.initial,
    this.news = const <News>[],
    this.hasReachedMax = false,
  });

  final NewsStatus status;
  final List<News> news;
  final bool hasReachedMax;

  NewsState copyWith({
    NewsStatus? status,
    List<News>? news,
    bool? hasReachedMax,
  }) {
    return NewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, news: ${news.length} }''';
  }

  @override
  List<Object> get props => [status, news, hasReachedMax];
}
