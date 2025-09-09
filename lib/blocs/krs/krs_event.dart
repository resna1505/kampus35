part of 'krs_bloc.dart';

sealed class KrsEvent extends Equatable {
  const KrsEvent();

  @override
  List<Object> get props => [];
}

class KrsGet extends KrsEvent {}
