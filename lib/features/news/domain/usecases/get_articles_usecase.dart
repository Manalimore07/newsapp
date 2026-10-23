import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class GetArticlesUseCase {
  final NewsRepository repository;

  GetArticlesUseCase(this.repository);

  Future<List<ArticleEntity>> call({bool forceRefresh = false}) async {
    return await repository.getArticles(forceRefresh: forceRefresh);
  }
}
