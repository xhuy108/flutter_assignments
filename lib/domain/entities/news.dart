import 'package:equatable/equatable.dart';

class News extends Equatable {
  final int id;
  final String title;
  final String summary;
  final String modifiedAt;
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
