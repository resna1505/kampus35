part of 'nilai_bloc.dart';

sealed class NilaiState extends Equatable {
  const NilaiState();

  @override
  List<Object> get props => [];
}

final class NilaiInitial extends NilaiState {}

final class NilaiLoadig extends NilaiState {}

final class NilaiFailed extends NilaiState {
  final String e;
  const NilaiFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class NilaiSuccess extends NilaiState {
  final List<NilaiModel> nilai;

  const NilaiSuccess(this.nilai);

  @override
  List<Object> get props => [nilai];
}
