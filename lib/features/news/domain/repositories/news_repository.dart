import '../entities/article_entity.dart';

abstract class NewsRepository {
  /// Fetches articles from remote/mock source and caches them locally
  Future<List<ArticleEntity>> getArticles({bool forceRefresh = false});

  /// Searches articles by title or description
  Future<List<ArticleEntity>> searchArticles(String query);

  /// Retrieves articles stored in local cache
  Future<List<ArticleEntity>> getCachedArticles();
}
