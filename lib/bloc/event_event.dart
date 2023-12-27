part of 'event_bloc.dart';

@immutable
sealed class EventEvent {}

final class EventFetched extends EventEvent {
  final int eventId;

  EventFetched({required this.eventId});
}
