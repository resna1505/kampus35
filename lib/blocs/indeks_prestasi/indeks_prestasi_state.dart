part of 'indeks_prestasi_bloc.dart';

sealed class IndeksPrestasiState extends Equatable {
  const IndeksPrestasiState();

  @override
  List<Object> get props => [];
}

final class IndeksPrestasiInitial extends IndeksPrestasiState {}

final class IndeksPrestasiLoading extends IndeksPrestasiState {}

final class IndeksPrestasiFailed extends IndeksPrestasiState {
  final String e;
  const IndeksPrestasiFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class IndeksPrestasiSuccess extends IndeksPrestasiState {
  final IndeksPrestasiModel indeksprestasi;
  const IndeksPrestasiSuccess(this.indeksprestasi);

  @override
  List<Object> get props => [indeksprestasi];
}
