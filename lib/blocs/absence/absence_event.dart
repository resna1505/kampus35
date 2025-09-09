part of 'absence_bloc.dart';

sealed class AbsenceEvent extends Equatable {
  const AbsenceEvent();

  @override
  List<Object> get props => [];
}

class ConfirmAbsence extends AbsenceEvent {
  final String idMakul;
  final String idRuangan;
  const ConfirmAbsence(
    this.idMakul,
    this.idRuangan,
  );

  @override
  List<Object> get props => [idMakul, idRuangan];
}

class AbsenceGet extends AbsenceEvent {}
