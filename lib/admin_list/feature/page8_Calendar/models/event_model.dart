import 'package:intl/intl.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime start_time;
  final DateTime end_time;
  final String type;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.start_time,
    required this.end_time,
    required this.type,
  });

  // Map 형식으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': start_time.toIso8601String(),
      'end_time': end_time.toIso8601String(),
      'type': type,
    };
  }

  // Map에서 Event 객체로 변환하는 팩토리 메서드
  factory Event.fromMap(Map<String, dynamic> map) {
    final DateFormat dateFormat =
        DateFormat("EEE, dd MMM yyyy HH:mm:ss z"); // 포맷 문자열을 조정할 수 있습니다.
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      start_time: dateFormat.parse(map['start_time']),
      end_time: dateFormat.parse(map['end_time']),
      type: map['type'],
    );
  }

  // copyWith 메서드 추가
  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? type,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      start_time: startTime ?? this.start_time,
      end_time: endTime ?? this.end_time,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          start_time == other.start_time &&
          end_time == other.end_time &&
          type == other.type);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      start_time.hashCode ^
      end_time.hashCode ^
      type.hashCode;
}
