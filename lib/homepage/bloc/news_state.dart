part of 'news_bloc.dart';

@immutable
abstract class NewsState extends Equatable {
  @override
  List<dynamic> get props => [];
}

class NewsInitial extends NewsState {
  NewsInitial();
}

class NewsLoading extends NewsState {
  NewsLoading();
  @override
  List<dynamic> get props => [];
}

class AllNewsLoading extends NewsState {
  final HeadlineByCountry? model;

  final bool firstFetch;

  AllNewsLoading({this.model, required this.firstFetch});
  @override
  List<dynamic> get props => [model, firstFetch];
}

class TopHeadlinesLoaded extends NewsState {
  final HeadlineByCountry model;
  final bool reset;
  TopHeadlinesLoaded({required this.model, this.reset = false});
  @override
  List<Object> get props => [model];
}

class TopHeadlinesFailed extends NewsState {
  final String message;
  // final HeadlineByCountry? model;

  TopHeadlinesFailed({
    required this.message,
    // this.model,
  });
  @override
  List<dynamic> get props => [
        message,
        // model,
      ];
}

class AllNewsLoaded extends NewsState {
  final HeadlineByCountry model;
  AllNewsLoaded({required this.model});
  @override
  List<Object> get props => [model];
}

class AllNewsFailed extends NewsState {
  final String message;
  final HeadlineByCountry? model;

  AllNewsFailed({required this.message, this.model});
  @override
  List<dynamic> get props => [message, model];
}
