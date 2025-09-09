import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/schedule_model.dart';
import 'package:kampus/services/schedule_service.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial()) {
    on<ScheduleEvent>((event, emit) async {
      if (event is ScheduleGet) {
        try {
          emit(ScheduleLoading());

          final schedule = await ScheduleService().getSchedule();
          emit(ScheduleSuccess(schedule));
        } catch (e) {
          emit(ScheduleFailed(e.toString()));
        }
      }
    });
  }
}
