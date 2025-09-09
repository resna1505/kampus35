part of 'campus_news_bloc.dart';

sealed class CampusNewsEvent extends Equatable {
  const CampusNewsEvent();

  @override
  List<Object> get props => [];
}

class CampusNewsGet extends CampusNewsEvent {}
