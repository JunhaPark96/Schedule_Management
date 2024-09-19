import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/models/event_model.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_event.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_state.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/repos/calendar_repos.dart';
import 'package:logger/logger.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final logger = Logger();

  final CalendarRepository repository;

  EventBloc(this.repository) : super(EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<LoadEventsForDay>(_onLoadEventsForDay);
    on<AddEvent>(_onAddEvent);
    on<RemoveEvent>(_onRemoveEvent);
    on<UpdateEvent>(_onUpdateEvent);
  }

  void _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(EventLoadInProgress());
    try {
      final allEvents = await repository.getAllEvents(); // Repository 사용
      emit(EventLoadSuccess(allEvents));
    } catch (e) {
      emit(EventLoadFailure(e.toString()));
    }
  }

  void _onLoadEventsForDay(
      LoadEventsForDay event, Emitter<EventState> emit) async {
    emit(EventLoadInProgress());
    try {
      final eventsForDay =
          await repository.getEventsForDay(event.selectedDay); // Repository 사용
      logger.i('test : Events for ${event.selectedDay}: $eventsForDay'); // 로깅
      emit(EventLoadSuccess(eventsForDay));
    } catch (e) {
      logger.e('Failed to load events for ${event.selectedDay}: $e'); // 로깅
      emit(EventLoadFailure(e.toString()));
    }
  }

  void _onAddEvent(AddEvent event, Emitter<EventState> emit) async {
    emit(EventLoadInProgress());
    try {
      await repository.addEvent(event.event); // Repository 사용
      final allEvents = await repository.getAllEvents(); // 업데이트된 모든 이벤트 가져오기
      emit(EventLoadSuccess(allEvents));
    } catch (e) {
      emit(EventLoadFailure(e.toString()));
    }
  }

  void _onRemoveEvent(RemoveEvent event, Emitter<EventState> emit) async {
    emit(EventLoadInProgress());
    try {
      await repository.removeEvent(event.event); // Repository 사용
      final allEvents = await repository.getAllEvents(); // 업데이트된 모든 이벤트 가져오기
      emit(EventLoadSuccess(allEvents));
    } catch (e) {
      emit(EventLoadFailure(e.toString()));
    }
  }

  void _onUpdateEvent(UpdateEvent event, Emitter<EventState> emit) async {
    emit(EventLoadInProgress());
    try {
      await repository.updateEvent(event.updatedEvent); // Repository 사용
      final allEvents = await repository.getAllEvents(); // 업데이트된 모든 이벤트 가져오기
      emit(EventLoadSuccess(allEvents));
    } catch (e) {
      emit(EventLoadFailure(e.toString()));
    }
  }
}
