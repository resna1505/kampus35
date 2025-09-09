part of 'campus_news_bloc.dart';

sealed class CampusNewsState extends Equatable {
  const CampusNewsState();

  @override
  List<Object> get props => [];
}

final class CampusNewsInitial extends CampusNewsState {}

final class CampusNewsLoading extends CampusNewsState {}

final class CampusNewsFailed extends CampusNewsState {
  final String e;
  const CampusNewsFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class CampusNewsSuccess extends CampusNewsState {
  final List<CampusNewsModel> campusnews;

  const CampusNewsSuccess(this.campusnews);

  @override
  List<Object> get props => [campusnews];
}
