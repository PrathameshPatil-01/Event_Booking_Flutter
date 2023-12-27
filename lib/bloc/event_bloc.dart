import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_internet_folks/data/repository/event_repository.dart';
import 'package:the_internet_folks/models/post.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;
  EventBloc(this.eventRepository) : super(EventInitial()) {
    on<EventFetched>(fetchEventDetails);
  }

  void fetchEventDetails(EventFetched event, Emitter<EventState> emit) async {
    final eventId = event.eventId;
    emit(EventLoading());
    try {
      final event = await eventRepository.fetchEvent(eventId);
      emit(EventSuccess(event: event));
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }
}
