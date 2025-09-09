part of 'schedule_bloc.dart';

sealed class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

final class ScheduleInitial extends ScheduleState {}

final class ScheduleLoading extends ScheduleState {}

final class ScheduleFailed extends ScheduleState {
  final String e;
  const ScheduleFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class ScheduleSuccess extends ScheduleState {
  final List<ScheduleModel> schedule;

  const ScheduleSuccess(this.schedule);

  @override
  List<Object> get props => [schedule];
}
