import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:newzzy/db/bloc/repository/repository.dart';
import 'package:newzzy/homepage/models/top_headlines_by_country.dart';

part 'local_db_event.dart';
part 'local_db_state.dart';

class LocalDbBloc extends Bloc<LocalDbEvent, LocalDbState> {
  LocalDBRepository repository;
  LocalDbBloc({required this.repository}) : super(LocalDbInitial()) {
    on<LocalDbEvent>((event, emit) async {
      if (event is CreateArticleTable) {
        emit(LocalDBLoading());

        try {
          bool result = await repository.createArticleDB();
          if (result) {
            emit(ArticletableCreated(model: event.model));
          } else {
            emit(ArticletableFailed(message: 'Local Storge Error'));
          }
        } catch (e) {
          debugPrint(e.toString());
          emit(ArticletableFailed(message: 'Local Storge Error'));
        }
      } else if (event is BookMarkArticle) {
        emit(LocalDBLoading());
        try {
          bool result = await repository.insertToBookmarkDB(event.model);
          if (result) {
            emit(ArticleBookMarked());
          } else {
            emit(
                ArticleBookFailed(message: 'Articles could not be Bookmarked'));
          }
        } catch (e) {
          emit(ArticleBookFailed(message: 'Articles could not be Bookmarked'));
        }
      } else if (event is GetAllBookMakedArticle) {
        emit(LocalDBLoading());
        try {
          List<Articles> result = await repository.getAllArtiles();
          emit(BookmarkedArticleFound(model: result));
        } catch (e) {
          emit(BookmarkedArticleNotFound(message: 'No articles found'));
        }
      }
    });
  }
}
