import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/history_sks_model.dart';
import 'package:kampus/services/history_sks_service.dart';

part 'history_sks_event.dart';
part 'history_sks_state.dart';

class HistorySksBloc extends Bloc<HistorySksEvent, HistorySksState> {
  HistorySksBloc() : super(HistorySksInitial()) {
    on<HistorySksEvent>((event, emit) async {
      if (event is HistorySksGet) {
        try {
          emit(HistorySksLoading());

          final indeksprestasi = await HistorySksService().getHistorySks();
          emit(HistorySksSuccess(indeksprestasi));
        } catch (e) {
          emit(HistorySksFailed(e.toString()));
        }
      }
    });
  }
}
