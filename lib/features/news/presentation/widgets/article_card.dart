import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/article_entity.dart';

class ArticleCard extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Recent';
    return DateFormat('MMM d, y • h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = article.urlToImage != null &&
        article.urlToImage!.trim().isNotEmpty &&
        article.urlToImage!.startsWith('http');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image or Placeholder
            if (hasImage)
              Hero(
                tag: 'article_img_${article.url ?? article.title}',
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    article.urlToImage!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.newspaper_rounded,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.15),
                      theme.colorScheme.secondary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.article_outlined,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

            // Article Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source & Date Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (article.sourceName != null &&
                          article.sourceName!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            article.sourceName!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      Text(
                        _formatDate(article.publishedAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  // Description
                  if (article.description != null &&
                      article.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      article.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],

                  // Author
                  if (article.author != null &&
                      article.author!.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'By ${article.author!}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
