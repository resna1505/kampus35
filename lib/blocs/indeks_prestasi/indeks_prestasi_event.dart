part of 'indeks_prestasi_bloc.dart';

sealed class IndeksPrestasiEvent extends Equatable {
  const IndeksPrestasiEvent();

  @override
  List<Object> get props => [];
}

class IndeksPrestasiGet extends IndeksPrestasiEvent {}
