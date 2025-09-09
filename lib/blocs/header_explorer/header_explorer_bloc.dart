import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/header_explorer_model.dart';
import 'package:kampus/services/header_explore_service.dart';

part 'header_explorer_event.dart';
part 'header_explorer_state.dart';

class HeaderExplorerBloc
    extends Bloc<HeaderExplorerEvent, HeaderExplorerState> {
  HeaderExplorerBloc() : super(HeaderExplorerInitial()) {
    on<HeaderExplorerEvent>((event, emit) async {
      if (event is HeaderExplorerGet) {
        try {
          emit(HeaderExplorerLoading());

          final indeksprestasi =
              await HeaderExplorerService().getHeaderExplorer();
          emit(HeaderExplorerSuccess(indeksprestasi));
        } catch (e) {
          emit(HeaderExplorerFailed(e.toString()));
        }
      }
    });
  }
}
