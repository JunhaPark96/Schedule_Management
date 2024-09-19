import 'package:equatable/equatable.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/models/event_model.dart';

abstract class EventEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCalendar extends EventEvent {}

class LoadEvents extends EventEvent {}

class LoadEventsForDay extends EventEvent {
  final DateTime selectedDay;

  LoadEventsForDay(this.selectedDay);

  @override
  List<Object> get props => [selectedDay];
}

class AddEvent extends EventEvent {
  final Event event;

  AddEvent(this.event);

  @override
  List<Object> get props => [event];
}

class RemoveEvent extends EventEvent {
  final Event event;

  RemoveEvent(this.event);

  @override
  List<Object> get props => [event];
}

class UpdateEvent extends EventEvent {
  final Event updatedEvent;

  UpdateEvent(this.updatedEvent);

  @override
  List<Object> get props => [updatedEvent];
}
