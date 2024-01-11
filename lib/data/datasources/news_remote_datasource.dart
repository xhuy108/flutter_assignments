import 'package:bai5/core/errors/exception.dart';
import 'package:bai5/data/models/news_model.dart';
import 'package:dio/dio.dart';

abstract class NewsRemoteDataSource {
  const NewsRemoteDataSource();

  Future<List<NewsModel>> getNews();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio client;

  NewsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<NewsModel>> getNews() async {
    try {
      final response = await client.get(
        'http://54.226.141.124/intern/news?page=1',
      );

      return response.data
          .map<NewsModel>((json) => NewsModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message!, 500);
    }
  }
}
