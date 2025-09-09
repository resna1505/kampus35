part of 'biodata_bloc.dart';

sealed class BiodataEvent extends Equatable {
  const BiodataEvent();

  @override
  List<Object> get props => [];
}

class BiodataGet extends BiodataEvent {}
