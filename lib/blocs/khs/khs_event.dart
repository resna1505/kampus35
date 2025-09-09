part of 'khs_bloc.dart';

sealed class KhsEvent extends Equatable {
  const KhsEvent();

  @override
  List<Object> get props => [];
}

class KhsGet extends KhsEvent {}
