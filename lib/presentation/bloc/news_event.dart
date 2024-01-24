part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

final class NewsFetched extends NewsEvent {
  const NewsFetched({required this.page});

  final int page;

  @override
  List<Object> get props => [page];
}

final class FirstTimeCached extends NewsEvent {
  const FirstTimeCached();

  @override
  List<Object> get props => [];
}
