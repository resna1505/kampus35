part of 'biodata_bloc.dart';

sealed class BiodataState extends Equatable {
  const BiodataState();

  @override
  List<Object> get props => [];
}

final class BiodataInitial extends BiodataState {}

final class BiodataLoading extends BiodataState {}

final class BiodataFailed extends BiodataState {
  final String e;
  const BiodataFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class BiodataSuccess extends BiodataState {
  final BiodataModel biodata;
  const BiodataSuccess(this.biodata);

  @override
  List<Object> get props => [biodata];
}
