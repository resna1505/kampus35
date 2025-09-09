part of 'header_explorer_bloc.dart';

sealed class HeaderExplorerState extends Equatable {
  const HeaderExplorerState();

  @override
  List<Object> get props => [];
}

final class HeaderExplorerInitial extends HeaderExplorerState {}

final class HeaderExplorerLoading extends HeaderExplorerState {}

final class HeaderExplorerFailed extends HeaderExplorerState {
  final String e;
  const HeaderExplorerFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class HeaderExplorerSuccess extends HeaderExplorerState {
  final HeaderExplorerModel headerexplorer;
  const HeaderExplorerSuccess(this.headerexplorer);

  @override
  List<Object> get props => [headerexplorer];
}
