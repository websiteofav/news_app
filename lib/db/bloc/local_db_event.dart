part of 'local_db_bloc.dart';

abstract class LocalDbEvent extends Equatable {
  const LocalDbEvent();

  @override
  List<Object> get props => [];
}

class CreateArticleTable extends LocalDbEvent {
  final Articles model;
  CreateArticleTable({required this.model});
  List<Object> get props => [model];
}

class BookMarkArticle extends LocalDbEvent {
  final Articles model;

  BookMarkArticle({required this.model});

  @override
  List<Object> get props => [model];
}

class GetAllBookMakedArticle extends LocalDbEvent {
  GetAllBookMakedArticle();

  @override
  List<Object> get props => [];
}
