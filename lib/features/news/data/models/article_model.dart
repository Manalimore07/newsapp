import '../../domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required super.title,
    super.description,
    super.content,
    super.author,
    super.url,
    super.urlToImage,
    super.publishedAt,
    super.sourceName,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['publishedAt'] != null) {
      try {
        parsedDate = DateTime.parse(json['publishedAt'] as String);
      } catch (_) {
        parsedDate = null;
      }
    }

    String? source;
    if (json['source'] != null && json['source'] is Map) {
      source = json['source']['name']?.toString();
    } else if (json['sourceName'] != null) {
      source = json['sourceName']?.toString();
    }

    return ArticleModel(
      title: json['title'] as String? ?? 'Untitled News',
      description: json['description'] as String?,
      content: json['content'] as String?,
      author: json['author'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: parsedDate,
      sourceName: source,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt?.toIso8601String(),
      'sourceName': sourceName,
    };
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      title: entity.title,
      description: entity.description,
      content: entity.content,
      author: entity.author,
      url: entity.url,
      urlToImage: entity.urlToImage,
      publishedAt: entity.publishedAt,
      sourceName: entity.sourceName,
    );
  }
}
