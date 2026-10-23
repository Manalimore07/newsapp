import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/article_entity.dart';

class ArticleDetailScreen extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailScreen({super.key, required this.article});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Recent';
    return DateFormat('MMMM d, y • h:mm a').format(date);
  }

  Future<void> _openArticleUrl(BuildContext context) async {
    if (article.url == null || article.url!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No external URL available for this article.')),
      );
      return;
    }

    final uri = Uri.tryParse(article.url!);
    if (uri != null) {
      try {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open article link.')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error launching URL: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = article.urlToImage != null &&
        article.urlToImage!.trim().isNotEmpty &&
        article.urlToImage!.startsWith('http');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.sourceName ?? 'Article Details',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          if (article.url != null && article.url!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.open_in_browser_rounded),
              tooltip: 'Open in Browser',
              onPressed: () => _openArticleUrl(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            if (hasImage)
              Hero(
                tag: 'article_img_${article.url ?? article.title}',
                child: SizedBox(
                  width: double.infinity,
                  height: 260,
                  child: Image.network(
                    article.urlToImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image_outlined, size: 50),
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source Tag
                  if (article.sourceName != null &&
                      article.sourceName!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        article.sourceName!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    article.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Meta Row: Author & Date
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(article.publishedAt),
                        style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  if (article.author != null &&
                      article.author!.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person_rounded,
                          size: 16,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Written by ${article.author!}',
                            style: TextStyle(
                              color: theme.colorScheme.outline,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const Divider(height: 36),

                  // Content Body
                  Text(
                    article.content ??
                        article.description ??
                        'No detailed content available for this news item.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.7,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Call-to-action button: Open original URL
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () => _openArticleUrl(context),
                      icon: const Icon(Icons.launch_rounded),
                      label: const Text(
                        'Read Full Original Story',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
