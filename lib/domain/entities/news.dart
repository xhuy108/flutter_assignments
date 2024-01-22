import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'news.g.dart';

@HiveType(typeId: 0)
class News extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String summary;

  @HiveField(3)
  final String modifiedAt;

  @HiveField(4)
  final String image;

  const News({
    required this.id,
    required this.title,
    required this.summary,
    required this.modifiedAt,
    required this.image,
  });

  @override
  List<Object?> get props => [id, title, summary, modifiedAt, image];
}
