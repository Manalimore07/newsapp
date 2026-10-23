import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_mock_data_source.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<ArticleEntity>> getArticles({bool forceRefresh = false}) async {
    try {
      // 1. Fetch fresh data from remote/mock source
      final List<ArticleModel> remoteArticles =
          await remoteDataSource.getTopHeadlines();

      // 2. Cache newly fetched articles into Hive for offline usage
      if (remoteArticles.isNotEmpty) {
        await localDataSource.cacheArticles(remoteArticles);
      }

      return remoteArticles;
    } catch (e) {
      // 3. Fallback to Hive local cache if remote fetch fails
      final List<ArticleModel> cachedArticles =
          await localDataSource.getCachedArticles();

      if (cachedArticles.isNotEmpty) {
        return cachedArticles;
      }
      rethrow;
    }
  }

  @override
  Future<List<ArticleEntity>> searchArticles(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      return getArticles();
    }

    // Load available articles (from remote or local cache)
    List<ArticleEntity> allArticles;
    try {
      allArticles = await getArticles();
    } catch (_) {
      allArticles = await getCachedArticles();
    }

    // Filter by title, description, or content
    return allArticles.where((article) {
      final titleMatch = article.title.toLowerCase().contains(cleanQuery);
      final descMatch =
          article.description?.toLowerCase().contains(cleanQuery) ?? false;
      final contentMatch =
          article.content?.toLowerCase().contains(cleanQuery) ?? false;
      final authorMatch =
          article.author?.toLowerCase().contains(cleanQuery) ?? false;

      return titleMatch || descMatch || contentMatch || authorMatch;
    }).toList();
  }

  @override
  Future<List<ArticleEntity>> getCachedArticles() async {
    return await localDataSource.getCachedArticles();
  }
}
