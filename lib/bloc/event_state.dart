part of 'event_bloc.dart';

@immutable
sealed class EventState {}

final class EventInitial extends EventState {}

final class EventSuccess extends EventState {
  final Post event;

  EventSuccess({required this.event});
}

final class EventFailure extends EventState {
  final String error;
  EventFailure(this.error);
}

final class EventLoading extends EventState {}
