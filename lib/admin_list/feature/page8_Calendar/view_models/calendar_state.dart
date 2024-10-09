import 'package:equatable/equatable.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/models/event_model.dart';

abstract class EventState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoadInProgress extends EventState {}

class EventLoadSuccess extends EventState {
  final List<Event> events;

  EventLoadSuccess(this.events);

  @override
  List<Object> get props => [events];
}

class EventLoadFailure extends EventState {
  final String error;

  EventLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
