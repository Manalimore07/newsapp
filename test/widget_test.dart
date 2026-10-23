import 'package:flutter_test/flutter_test.dart';
import 'package:newsapp/features/news/data/models/article_model.dart';

void main() {
  group('ArticleModel Test', () {
    final tArticleJson = {
      'source': {'id': 'test', 'name': 'TechCrunch'},
      'author': 'John Doe',
      'title': 'Flutter in 2026',
      'description': 'Flutter Clean Architecture test',
      'url': 'https://flutter.dev',
      'urlToImage': 'https://image.url',
      'publishedAt': '2026-10-23T10:00:00Z',
      'content': 'Comprehensive Flutter guide.',
    };

    test('should parse JSON correctly into ArticleModel', () {
      // Act
      final result = ArticleModel.fromJson(tArticleJson);

      // Assert
      expect(result.title, 'Flutter in 2026');
      expect(result.author, 'John Doe');
      expect(result.sourceName, 'TechCrunch');
      expect(result.description, 'Flutter Clean Architecture test');
      expect(result.publishedAt, DateTime.parse('2026-10-23T10:00:00Z'));
    });

    test('should handle null/missing values gracefully without throwing', () {
      final tIncompleteJson = {
        'title': null,
        'publishedAt': 'invalid-date',
      };

      final result = ArticleModel.fromJson(tIncompleteJson);

      expect(result.title, 'Untitled News');
      expect(result.author, isNull);
      expect(result.publishedAt, isNull);
      expect(result.urlToImage, isNull);
    });

    test('should serialize ArticleModel back to Map correctly', () {
      final model = ArticleModel.fromJson(tArticleJson);
      final jsonMap = model.toJson();

      expect(jsonMap['title'], 'Flutter in 2026');
      expect(jsonMap['author'], 'John Doe');
      expect(jsonMap['sourceName'], 'TechCrunch');
    });
  });
}
