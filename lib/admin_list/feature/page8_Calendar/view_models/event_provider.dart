import 'package:flutter/material.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/models/event_model.dart';

class EventProvider with ChangeNotifier {
  final Map<DateTime, List<Event>> _events = {
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
      Event(
        id: 1,
        title: 'repcap01 서버 백신 패치 업데이트 작업',
        description: '14시부터 16시까지 repcap01 서버 백신 패치 업데이트 작업',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 14, 0),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 16, 0),
        type: 'maintenance',
      ),
      Event(
        id: 2,
        title: 'pepeap 01 서버 백신 패치 업데이트 작업',
        description: '16시부터 17시까지 repcap01 서버 백신 패치 업데이트 작업',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 16, 0),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 17, 0),
        type: 'maintenance',
      ),
    ]
  };

  List<Event> getEventsForDay(DateTime day) {
    DateTime key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  List<Event> getAllEvents() {
    List<Event> allEvents = [];
    _events.values.forEach((events) {
      allEvents.addAll(events);
    });
    return allEvents;
  }

  void addEvent(Event event) {
    final date = DateTime(
        event.startTime.year, event.startTime.month, event.startTime.day);
    if (_events[date] != null) {
      _events[date]!.add(event);
    } else {
      _events[date] = [event];
    }
    notifyListeners();
  }

  void removeEvent(Event event) {
    final date = DateTime(
        event.startTime.year, event.startTime.month, event.startTime.day);
    _events[date]?.removeWhere(
        (e) => e.title == event.title && e.startTime == event.startTime);
    notifyListeners();
  }

  void updateEvent(Event updatedEvent) {
    final date = DateTime(updatedEvent.startTime.year,
        updatedEvent.startTime.month, updatedEvent.startTime.day);
    final index =
        _events[date]?.indexWhere((event) => event.id == updatedEvent.id);
    if (index != null && index != -1) {
      _events[date]?[index] = updatedEvent;
      notifyListeners();
    }
  }
}
