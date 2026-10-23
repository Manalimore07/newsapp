import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines();
}

class NewsMockDataSourceImpl implements NewsRemoteDataSource {
  final String assetPath;

  NewsMockDataSourceImpl({this.assetPath = AppConstants.mockNewsPath});

  @override
  Future<List<ArticleModel>> getTopHeadlines() async {
    // Simulate realistic network latency for the UI (pull-to-refresh, shimmer/loading state)
    await Future.delayed(const Duration(milliseconds: 650));

    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> data = json.decode(jsonString);

      if (data['articles'] != null && data['articles'] is List) {
        final List<dynamic> articleList = data['articles'];
        return articleList
            .map((item) => ArticleModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load mock news data: $e');
    }
  }
}
