part of 'history_sks_bloc.dart';

sealed class HistorySksEvent extends Equatable {
  const HistorySksEvent();

  @override
  List<Object> get props => [];
}

class HistorySksGet extends HistorySksEvent {}
