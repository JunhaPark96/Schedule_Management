import 'package:flutter/material.dart';
import 'package:oneline/models/event_model.dart';

class EventProvider with ChangeNotifier {
  final Map<DateTime, List<Event>> _events = {
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
      Event(
        title: 'repcap01 서버 백신 패치 업데이트 작업',
        description: '14시부터 16시까지 repcap01 서버 백신 패치 업데이트 작업',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 14, 0),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 16, 0),
        type: 'maintenance',
      ),
      Event(
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
    print('Getting events for: $key');
    print('Events: ${_events[key]}');
    return _events[key] ?? [];
  }

  void addEvent(Event event) {
    final date = DateTime(
        event.startTime.year, event.startTime.month, event.startTime.day);
    if (_events[date] != null) {
      _events[date]!.add(event);
    } else {
      _events[date] = [event];
    }
    print('Event added on: $date');
    notifyListeners();
  }

  void removeEvent(Event event) {
    final date = DateTime(
        event.startTime.year, event.startTime.month, event.startTime.day);
    _events[date]?.remove(event);
    print('Event removed on: $date');
    notifyListeners();
  }
}
