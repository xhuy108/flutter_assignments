import 'package:bai5/domain/entities/news.dart';

class NewsModel extends News {
  const NewsModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.modifiedAt,
    required super.image,
  });

  factory NewsModel.fromEntity(News news) {
    return NewsModel(
      id: news.id,
      title: news.title,
      summary: news.summary,
      modifiedAt: news.modifiedAt,
      image: news.image,
    );
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['storyId'] as int,
      title: json['title'] as String,
      summary: json['summary'] as String,
      modifiedAt: json['modifiedAt'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storyId': id,
      'title': title,
      'summary': summary,
      'modifiedAt': modifiedAt,
      'image': image,
    };
  }
}
