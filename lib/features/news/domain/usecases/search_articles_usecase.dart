import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class SearchArticlesUseCase {
  final NewsRepository repository;

  SearchArticlesUseCase(this.repository);

  Future<List<ArticleEntity>> call(String query) async {
    return await repository.searchArticles(query);
  }
}
