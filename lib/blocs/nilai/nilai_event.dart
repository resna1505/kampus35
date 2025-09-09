part of 'nilai_bloc.dart';

sealed class NilaiEvent extends Equatable {
  const NilaiEvent();

  @override
  List<Object> get props => [];
}

class NilaiGet extends NilaiEvent {}
