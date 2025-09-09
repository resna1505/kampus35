import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/khs_model.dart';
import 'package:kampus/services/khs_service.dart';

part 'khs_event.dart';
part 'khs_state.dart';

class KhsBloc extends Bloc<KhsEvent, KhsState> {
  KhsBloc() : super(KhsInitial()) {
    on<KhsEvent>((event, emit) async {
      if (event is KhsGet) {
        try {
          emit(KhsLoading());

          final khs = await KhsService().getKhs();
          emit(KhsSuccess(khs));
        } catch (e) {
          emit(KhsFailed(e.toString()));
        }
      }
    });
  }
}
