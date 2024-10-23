// calendar_repos.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oneline2/admin_list/feature/page8_Calendar/models/event_model.dart';
import 'package:logger/logger.dart';

class CalendarRepository {
  final String baseUrl = 'http://52.78.12.208:5050';
  final List<Event> _events = [];
  final logger = Logger();

  CalendarRepository() {
    // GetIt에 등록되어 있어야 함
    generateSampleData();
  }

  // 임의의 일정 데이터 생성 메서드
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

  // 모든 이벤트를 비동기적으로 가져오는 메서드
  Future<List<Event>> getAllEvents() async {
    return List.unmodifiable(_events);
    // final url = Uri.parse('$baseUrl/events'); // 서버 엔드포인트
    // try {
    //   final response = await http.get(url);

    //   if (response.statusCode == 200) {
    //     List<dynamic> data = jsonDecode(response.body);
    //     return data.map((eventData) => Event.fromMap(eventData)).toList();
    //   } else {
    //     throw Exception('Failed to load events');
    //   }
    // } catch (e) {
    //   logger.e('Error fetching events: $e');
    //   return [];
    // }
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
    // final url =
    //     Uri.parse('$baseUrl/event?date=${selectedDay.toIso8601String()}');

    // try {
    //   final response = await http.get(url);

    //   if (response.statusCode == 200) {
    //     List<dynamic> data = jsonDecode(response.body);
    //     return data.map((eventData) => Event.fromMap(eventData)).toList();
    //   } else {
    //     throw Exception('Failed to load events for the selected day');
    //   }
    // } catch (e) {
    //   logger.e('Error fetching events for day: $e');
    //   return [];
    // }
  }

  // 이벤트 추가 메서드
  Future<void> addEvent(Event event) async {
    _events.add(event);
    //   final url = Uri.parse('$baseUrl/event-add');
    //   try {
    //     final response = await http.post(
    //       url,
    //       headers: {
    //         'Content-Type': 'application/json',
    //       },
    //       body: jsonEncode(event.toMap()),
    //     );

    //     if (response.statusCode == 201) {
    //       logger.i('Event added successfully');
    //     } else {
    //       throw Exception('Failed to add event');
    //     }
    //   } catch (e) {
    //     logger.e('Error adding event: $e');
    //   }
    // }
  }

  // 이벤트 삭제 메서드
  Future<void> removeEvent(int eventId) async {
    _events.removeWhere((e) => e.id == eventId);
    // final url = Uri.parse('$baseUrl/event/$eventId');

    // try {
    //   final response = await http.delete(url);

    //   if (response.statusCode == 200) {
    //     logger.i('Event deleted successfully');
    //   } else {
    //     throw Exception('Failed to delete event');
    //   }
    // } catch (e) {
    //   logger.e('Error deleting event: $e');
    // }
  }

  // 이벤트 업데이트 메서드
  Future<void> updateEvent(Event updatedEvent) async {
    final index = _events.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
    }
    //   final url = Uri.parse('$baseUrl/events/${updatedEvent.id}');

    //   try {
    //     final response = await http.put(
    //       url,
    //       headers: {
    //         'Content-Type': 'application/json',
    //       },
    //       body: jsonEncode(updatedEvent.toMap()),
    //     );

    //     if (response.statusCode == 200) {
    //       logger.i('Event updated successfully');
    //     } else {
    //       throw Exception('Failed to update event');
    //     }
    //   } catch (e) {
    //     logger.e('Error updating event: $e');
    //   }
    // }
  }
}