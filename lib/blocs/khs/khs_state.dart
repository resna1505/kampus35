part of 'khs_bloc.dart';

sealed class KhsState extends Equatable {
  const KhsState();

  @override
  List<Object> get props => [];
}

final class KhsInitial extends KhsState {}

final class KhsLoading extends KhsState {}

final class KhsFailed extends KhsState {
  final String e;
  const KhsFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class KhsSuccess extends KhsState {
  final List<KhsModel> khs;

  const KhsSuccess(this.khs);

  @override
  List<Object> get props => [khs];
}
