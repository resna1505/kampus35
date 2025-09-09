import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/campus_news_model.dart';
import 'package:kampus/services/campus_news_service.dart';

part 'campus_news_event.dart';
part 'campus_news_state.dart';

class CampusNewsBloc extends Bloc<CampusNewsEvent, CampusNewsState> {
  CampusNewsBloc() : super(CampusNewsInitial()) {
    on<CampusNewsEvent>((event, emit) async {
      if (event is CampusNewsGet) {
        try {
          emit(CampusNewsLoading());

          final krs = await CampusNewsService().getCampusNews();
          emit(CampusNewsSuccess(krs));
        } catch (e) {
          emit(CampusNewsFailed(e.toString()));
        }
      }
    });
  }
}
