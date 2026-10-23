import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/news_cubit.dart';
import '../cubit/news_state.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    context.read<NewsCubit>().searchNews(query);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: _onQueryChanged,
            decoration: InputDecoration(
              hintText: 'Search news by title or content...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onQueryChanged('');
                        setState(() {});
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NewsLoaded) {
            if (state.articles.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 72,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No matching articles found',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try searching for different keywords like "Flutter", "AI", or "Space".',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.colorScheme.outline),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                return ArticleCard(
                  article: article,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            );
          }

          if (state is NewsError) {
            return Center(
              child: Text(state.message),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
