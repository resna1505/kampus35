part of 'absence_bloc.dart';

sealed class AbsenceState extends Equatable {
  const AbsenceState();

  @override
  List<Object> get props => [];
}

final class AbsenceInitial extends AbsenceState {}

final class AbsenceLoading extends AbsenceState {}

final class AbsenceFailed extends AbsenceState {
  final String e;
  const AbsenceFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class AbsenceSuccess extends AbsenceState {
  final List<AbsenceModel> absence;

  const AbsenceSuccess(this.absence);

  @override
  List<Object> get props => [absence];
}
