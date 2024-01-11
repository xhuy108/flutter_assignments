import 'package:bai5/core/errors/failure.dart';
import 'package:bai5/domain/entities/news.dart';
import 'package:dartz/dartz.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<News>>> getNews();
}
