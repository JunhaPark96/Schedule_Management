// calendar_repos.dart
import 'dart:convert';
import 'package:oneline2/admin_list/feature/page8_Calendar/models/event_model.dart';
import 'package:logger/logger.dart';

class CalendarRepository {
  final List<Event> _events = [];
  final logger = Logger();

  CalendarRepository() {
    generateSampleData();
  }

  // 모든 이벤트를 비동기적으로 가져오는 메서드
  Future<List<Event>> getAllEvents() async {
    return List.unmodifiable(_events);
  }

  // 특정 날짜의 이벤트를 비동기적으로 가져오는 메서드
  Future<List<Event>> getEventsForDay(DateTime selectedDay) async {
    final allEvents = await getAllEvents();

    final startOfDay =
        DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);
    final endOfDay = DateTime.utc(
        selectedDay.year, selectedDay.month, selectedDay.day, 23, 59, 59, 999);

    logger.i('Selected Day (UTC): $startOfDay to $endOfDay');
    logger.i(
        'All Events (UTC): ${allEvents.map((e) => '${e.title} - ${e.startTime.toUtc()} to ${e.endTime.toUtc()}')}');

    final filteredEvents = allEvents.where((event) {
      final eventStart = event.startTime.toUtc();
      final eventEnd = event.endTime.toUtc();

      final isWithinRange =
          (eventStart.isBefore(endOfDay) && eventEnd.isAfter(startOfDay));

      logger.i('Checking Event: ${event.title}');
      logger.i('Event Start Time (UTC): $eventStart');
      logger.i('Event End Time (UTC): $eventEnd');
      logger.i('Is Within Range: $isWithinRange');

      return isWithinRange;
    }).toList();

    logger.i('Filtered Events: $filteredEvents');

    return filteredEvents;
  }

  // 이벤트 추가 메서드
  Future<void> addEvent(Event event) async {
    _events.add(event);
  }

  // 이벤트 삭제 메서드
  Future<void> removeEvent(Event event) async {
    _events.removeWhere((e) => e.id == event.id);
  }

  // 이벤트 업데이트 메서드
  Future<void> updateEvent(Event updatedEvent) async {
    final index = _events.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
    }
  }

  // 임의의 데이터 생성 메서드
  void generateSampleData() {
    _events.add(Event(
      id: 1,
      title: "회의",
      description: "팀 회의",
      startTime: DateTime(2024, 9, 20, 10, 0),
      endTime: DateTime(2024, 9, 20, 11, 0),
      type: "회의",
    ));

    _events.add(Event(
      id: 2,
      title: "점심",
      description: "점심 시간",
      startTime: DateTime(2024, 9, 20, 12, 0),
      endTime: DateTime(2024, 9, 20, 13, 0),
      type: "식사",
    ));

    _events.add(Event(
      id: 3,
      title: "프로젝트 마감",
      description: "프로젝트 제출 마감",
      startTime: DateTime(2024, 9, 25, 17, 0),
      endTime: DateTime(2024, 9, 25, 18, 0),
      type: "기타",
    ));

    _events.add(Event(
      id: 4,
      title: "고객 미팅",
      description: "고객과의 미팅",
      startTime: DateTime(2024, 9, 22, 14, 0),
      endTime: DateTime(2024, 9, 22, 15, 30),
      type: "미팅",
    ));

    _events.add(Event(
      id: 5,
      title: "부서 워크샵",
      description: "부서 단합을 위한 워크샵",
      startTime: DateTime(2024, 9, 28, 9, 0),
      endTime: DateTime(2024, 9, 29, 17, 0),
      type: "워크샵",
    ));
  }
}
