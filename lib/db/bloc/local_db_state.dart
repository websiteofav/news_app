part of 'local_db_bloc.dart';

abstract class LocalDbState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocalDbInitial extends LocalDbState {}

class ArticletableCreated extends LocalDbState {
  final Articles model;

  ArticletableCreated({required this.model});
  @override
  List<Object> get props => [model];
}

// class LocalDBLoading extends LocalDbState {

// }

class LocalDBLoading extends LocalDbState {
  LocalDBLoading();
  @override
  List<Object> get props => [];
}

class ArticletableFailed extends LocalDbState {
  final String message;

  ArticletableFailed({required this.message});
  @override
  List<Object> get props => [];
}

class ArticleBookMarked extends LocalDbState {
  ArticleBookMarked();
  @override
  List<Object> get props => [];
}

class ArticleBookFailed extends LocalDbState {
  final String message;

  ArticleBookFailed({required this.message});
  @override
  List<Object> get props => [];
}

class BookmarkedArticleFound extends LocalDbState {
  final List<Articles> model;

  BookmarkedArticleFound({required this.model});

  @override
  List<Object> get props => [model];
}

class BookmarkedArticleNotFound extends LocalDbState {
  final String message;

  BookmarkedArticleNotFound({required this.message});

  @override
  List<Object> get props => [message];
}
