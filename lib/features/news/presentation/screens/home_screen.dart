import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../cubit/news_cubit.dart';
import '../cubit/news_state.dart';
import '../cubit/theme_cubit.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.flash_on_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppConstants.appTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          // Search Action Button
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search articles',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<NewsCubit>(),
                    child: const SearchScreen(),
                  ),
                ),
              ).then((_) {
                // Reset search when returning back to Home
                if (context.mounted) {
                  context.read<NewsCubit>().fetchNews();
                }
              });
            },
          ),

          // Theme Switcher Button (Light / Dark Mode)
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark ||
                  (themeMode == ThemeMode.system &&
                      MediaQuery.of(context).platformBrightness ==
                          Brightness.dark);

              return IconButton(
                icon: Icon(
                  isDark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_outlined,
                ),
                tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading latest headlines...',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }

          if (state is NewsLoaded) {
            if (state.articles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.newspaper_rounded, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No articles available at this moment.'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () =>
                          context.read<NewsCubit>().fetchNews(forceRefresh: true),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<NewsCubit>().fetchNews(forceRefresh: true);
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
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
              ),
            );
          }

          if (state is NewsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded,
                        size: 64, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Something went wrong',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.colorScheme.outline),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => context
                          .read<NewsCubit>()
                          .fetchNews(forceRefresh: true),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
