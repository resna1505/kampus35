import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/transcript_model.dart';
import 'package:kampus/services/transcript_service.dart';

part 'transcript_event.dart';
part 'transcript_state.dart';

class TranscriptBloc extends Bloc<TranscriptEvent, TranscriptState> {
  TranscriptBloc() : super(TranscriptInitial()) {
    on<TranscriptEvent>((event, emit) async {
      if (event is TranscriptGet) {
        try {
          emit(TranscriptLoading());

          final khs = await TranscriptService().getTranscript();
          emit(TranscriptSuccess(khs));
        } catch (e) {
          emit(TranscriptFailed(e.toString()));
        }
      }
    });
  }
}
