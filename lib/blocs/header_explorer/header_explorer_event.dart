part of 'header_explorer_bloc.dart';

sealed class HeaderExplorerEvent extends Equatable {
  const HeaderExplorerEvent();

  @override
  List<Object> get props => [];
}

class HeaderExplorerGet extends HeaderExplorerEvent {}
