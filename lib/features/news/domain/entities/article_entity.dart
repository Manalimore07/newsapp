import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String title;
  final String? description;
  final String? content;
  final String? author;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? sourceName;

  const ArticleEntity({
    required this.title,
    this.description,
    this.content,
    this.author,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.sourceName,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        content,
        author,
        url,
        urlToImage,
        publishedAt,
        sourceName,
      ];
}
