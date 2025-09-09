part of 'krs_bloc.dart';

sealed class KrsState extends Equatable {
  const KrsState();

  @override
  List<Object> get props => [];
}

final class KrsInitial extends KrsState {}

final class KrsLoading extends KrsState {}

final class KrsFailed extends KrsState {
  final String e;
  const KrsFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class KrsSuccess extends KrsState {
  final List<KrsModel> krs;

  const KrsSuccess(this.krs);

  @override
  List<Object> get props => [krs];
}
