part of 'history_sks_bloc.dart';

sealed class HistorySksState extends Equatable {
  const HistorySksState();

  @override
  List<Object> get props => [];
}

final class HistorySksInitial extends HistorySksState {}

final class HistorySksLoading extends HistorySksState {}

final class HistorySksFailed extends HistorySksState {
  final String e;
  const HistorySksFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class HistorySksSuccess extends HistorySksState {
  final HistorySksModel historysks;
  const HistorySksSuccess(this.historysks);

  @override
  List<Object> get props => [historysks];
}
