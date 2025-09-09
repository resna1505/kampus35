part of 'transcript_bloc.dart';

sealed class TranscriptState extends Equatable {
  const TranscriptState();

  @override
  List<Object> get props => [];
}

final class TranscriptInitial extends TranscriptState {}

final class TranscriptLoading extends TranscriptState {}

final class TranscriptFailed extends TranscriptState {
  final String e;
  const TranscriptFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class TranscriptSuccess extends TranscriptState {
  final List<TranscriptModel> transcript;

  const TranscriptSuccess(this.transcript);

  @override
  List<Object> get props => [transcript];
}
