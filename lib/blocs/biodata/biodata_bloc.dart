import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/biodata_model.dart';
import 'package:kampus/services/biodata_service.dart';

part 'biodata_event.dart';
part 'biodata_state.dart';

class BiodataBloc extends Bloc<BiodataEvent, BiodataState> {
  BiodataBloc() : super(BiodataInitial()) {
    on<BiodataEvent>((event, emit) async {
      if (event is BiodataGet) {
        try {
          emit(BiodataLoading());

          final indeksprestasi = await BiodataService().getBiodata();
          emit(BiodataSuccess(indeksprestasi));
        } catch (e) {
          emit(BiodataFailed(e.toString()));
        }
      }
    });
  }
}
