import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_articles_usecase.dart';
import '../../domain/usecases/search_articles_usecase.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetArticlesUseCase getArticlesUseCase;
  final SearchArticlesUseCase searchArticlesUseCase;

  NewsCubit({
    required this.getArticlesUseCase,
    required this.searchArticlesUseCase,
  }) : super(NewsInitial());

  Future<void> fetchNews({bool forceRefresh = false}) async {
    // If not refreshing, emit loading state
    if (!forceRefresh) {
      emit(NewsLoading());
    }

    try {
      final articles = await getArticlesUseCase(forceRefresh: forceRefresh);
      emit(NewsLoaded(articles: articles, isOffline: false));
    } catch (e) {
      emit(NewsError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> searchNews(String query) async {
    if (query.trim().isEmpty) {
      return fetchNews();
    }

    emit(NewsLoading());
    try {
      final searchResults = await searchArticlesUseCase(query);
      emit(NewsLoaded(articles: searchResults, isOffline: false));
    } catch (e) {
      emit(NewsError('Failed to search articles: ${e.toString()}'));
    }
  }
}
