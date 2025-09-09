part of 'grafik_nilai_bloc.dart';

sealed class GrafikNilaiEvent extends Equatable {
  const GrafikNilaiEvent();

  @override
  List<Object> get props => [];
}

class GrafikNilaiGet extends GrafikNilaiEvent {}
