part of 'grafik_nilai_bloc.dart';

sealed class GrafikNilaiState extends Equatable {
  const GrafikNilaiState();

  @override
  List<Object> get props => [];
}

final class GrafikNilaiInitial extends GrafikNilaiState {}

final class GrafikNilaiLoading extends GrafikNilaiState {}

final class GrafikNilaiFailed extends GrafikNilaiState {
  final String e;
  const GrafikNilaiFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class GrafikNilaiSuccess extends GrafikNilaiState {
  final List<GrafikNilaiModel> grafiknilai;

  const GrafikNilaiSuccess(this.grafiknilai);

  @override
  List<Object> get props => [grafiknilai];
}
