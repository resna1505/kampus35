import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/nilai_model.dart';
import 'package:kampus/services/nilai_service.dart';

part 'nilai_event.dart';
part 'nilai_state.dart';

class NilaiBloc extends Bloc<NilaiEvent, NilaiState> {
  NilaiBloc() : super(NilaiInitial()) {
    on<NilaiEvent>((event, emit) async {
      if (event is NilaiGet) {
        try {
          emit(NilaiLoadig());

          final krs = await NilaiService().getNilai();
          emit(NilaiSuccess(krs));
        } catch (e) {
          emit(NilaiFailed(e.toString()));
        }
      }
    });
  }
}
