import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/grafik_nilai_model.dart';
import 'package:kampus/services/grafik_nilai_service.dart';

part 'grafik_nilai_event.dart';
part 'grafik_nilai_state.dart';

class GrafikNilaiBloc extends Bloc<GrafikNilaiEvent, GrafikNilaiState> {
  GrafikNilaiBloc() : super(GrafikNilaiInitial()) {
    on<GrafikNilaiEvent>((event, emit) async {
      if (event is GrafikNilaiGet) {
        try {
          emit(GrafikNilaiLoading());

          final grafiknilai = await GrafikNilaiService().getGrafikNilai();
          emit(GrafikNilaiSuccess(grafiknilai));
        } catch (e) {
          emit(GrafikNilaiFailed(e.toString()));
        }
      }
    });
  }
}
