import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/absence_model.dart';
import 'package:kampus/services/absence_service.dart';

part 'absence_event.dart';
part 'absence_state.dart';

class AbsenceBloc extends Bloc<AbsenceEvent, AbsenceState> {
  AbsenceBloc() : super(AbsenceInitial()) {
    on<AbsenceEvent>((event, emit) async {
      if (event is AbsenceGet) {
        try {
          emit(AbsenceLoading());

          final krs = await AbsenceService().getAbsence();
          emit(AbsenceSuccess(krs));
        } catch (e) {
          emit(AbsenceFailed(e.toString()));
        }
      }

      if (event is ConfirmAbsence) {
        try {
          if (state is AbsenceSuccess) {
            // final updatedUser = (state as AbsenceSuccess).absence.copyWith(
            //       password: event.idMakul,
            //     );

            emit(AbsenceLoading());

            await AbsenceService().confirmAbsence(
              event.idMakul,
              event.idRuangan,
            );

            emit(AbsenceSuccess((state as AbsenceSuccess).absence));
          }
        } catch (e) {
          emit(AbsenceFailed(e.toString()));
        }
      }
    });
  }
}
