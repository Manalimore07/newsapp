import 'package:equatable/equatable.dart';
import '../../domain/entities/article_entity.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<ArticleEntity> articles;
  final bool isOffline;

  const NewsLoaded({
    required this.articles,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [articles, isOffline];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}
