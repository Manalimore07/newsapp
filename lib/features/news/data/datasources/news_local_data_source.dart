import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<void> cacheArticles(List<ArticleModel> articles);
  Future<List<ArticleModel>> getCachedArticles();
  Future<void> clearCache();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final Box newsBox;

  NewsLocalDataSourceImpl({required this.newsBox});

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    final List<Map<String, dynamic>> rawList =
        articles.map((article) => article.toJson()).toList();
    await newsBox.put(AppConstants.cachedArticlesKey, rawList);
  }

  @override
  Future<List<ArticleModel>> getCachedArticles() async {
    final dynamic cachedData = newsBox.get(AppConstants.cachedArticlesKey);

    if (cachedData != null && cachedData is List) {
      return cachedData
          .map((item) =>
              ArticleModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
    return [];
  }

  @override
  Future<void> clearCache() async {
    await newsBox.delete(AppConstants.cachedArticlesKey);
  }
}
