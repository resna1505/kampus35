import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/indeks_prestasi_model.dart';
import 'package:kampus/services/indeks_prestasi_service.dart';

part 'indeks_prestasi_event.dart';
part 'indeks_prestasi_state.dart';

class IndeksPrestasiBloc
    extends Bloc<IndeksPrestasiEvent, IndeksPrestasiState> {
  IndeksPrestasiBloc() : super(IndeksPrestasiInitial()) {
    on<IndeksPrestasiEvent>((event, emit) async {
      if (event is IndeksPrestasiGet) {
        try {
          emit(IndeksPrestasiLoading());

          final indeksprestasi =
              await IndeksPrestasiService().getIndeksPrestasi();
          emit(IndeksPrestasiSuccess(indeksprestasi));
        } catch (e) {
          emit(IndeksPrestasiFailed(e.toString()));
        }
      }
    });
  }
}
