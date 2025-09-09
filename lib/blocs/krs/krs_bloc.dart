import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/krs_model.dart';
import 'package:kampus/services/krs_service.dart';

part 'krs_event.dart';
part 'krs_state.dart';

class KrsBloc extends Bloc<KrsEvent, KrsState> {
  KrsBloc() : super(KrsInitial()) {
    on<KrsEvent>((event, emit) async {
      if (event is KrsGet) {
        try {
          emit(KrsLoading());

          final krs = await KrsService().getKrs();
          emit(KrsSuccess(krs));
        } catch (e) {
          emit(KrsFailed(e.toString()));
        }
      }
    });
  }
}
