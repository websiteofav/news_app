import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:newzzy/homepage/models/error_model.dart';
import 'package:newzzy/homepage/models/top_headlines_by_country.dart';
import 'package:newzzy/homepage/repository/news_repository.dart';
import 'package:dartz/dartz.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsRepository repository;

  NewsBloc({
    required this.repository,
  }) : super(NewsInitial()) {
    on<NewsEvent>((event, emit) async {
      if (event is FetchHeadlinesByCountry) {
        emit(NewsLoading());

        try {
          Either<HeadlineByCountry, ErrorModel> result =
              await repository.getTopHeadlinesByCountry(
            countryCode: event.countryCode,
            page: event.page,
          );

          result.fold((l) {
            emit(TopHeadlinesLoaded(
              model: l,
              reset: event.resetPage,
            ));
          }, (r) {
            emit(TopHeadlinesFailed(
              message: r.message.toString(),
            ));
          });
        } catch (e) {
          debugPrint(e.toString());
          emit(TopHeadlinesFailed(message: e.toString()));
        }
      } else if (event is FetchAllNews) {
        try {
          Either<HeadlineByCountry, ErrorModel> result =
              await repository.getAllNews(
            countryCode: event.countryCode,
            page: event.page,
          );

          result.fold((l) {
            emit(AllNewsLoaded(model: l));
          }, (r) {
            emit(AllNewsFailed(
              message: r.message.toString(),
            ));
          });
        } catch (e) {
          debugPrint(e.toString());
          emit(AllNewsFailed(message: e.toString()));
        }
      }
    });
  }
}
