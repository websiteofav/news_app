part of 'news_bloc.dart';

@immutable
abstract class NewsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchHeadlinesByCountry extends NewsEvent {
  final String countryCode;
  final bool resetPage;
  final int page;

  FetchHeadlinesByCountry(
      {required this.countryCode, required this.resetPage, required this.page});

  @override
  List<Object> get props => [countryCode];
}

class FetchAllNews extends NewsEvent {
  final String countryCode;
  final bool resetPage;
  final int page;

  FetchAllNews(
      {required this.countryCode, required this.resetPage, required this.page});

  @override
  List<Object> get props => [countryCode, resetPage];
}
