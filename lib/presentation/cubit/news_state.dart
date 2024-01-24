part of 'news_cubit.dart';

enum NewsStatus { initial, loading, success, failure }

final class NewsState extends Equatable {
  const NewsState({
    this.status = NewsStatus.initial,
    this.news = const <News>[],
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.error = '',
  });

  final NewsStatus status;
  final List<News> news;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String error;

  NewsState copyWith({
    NewsStatus? status,
    List<News>? news,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? error,
  }) {
    return NewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, error: $error, news: ${news.length} }''';
  }

  @override
  List<Object> get props => [status, news, hasReachedMax, isLoadingMore, error];
}
