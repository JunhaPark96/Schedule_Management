class Event {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String type;

  Event({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
  });

  // 추가: Map 형식으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(), // DateTime을 문자열로 변환
      'endTime': endTime.toIso8601String(), // DateTime을 문자열로 변환
      'type': type,
    };
  }

  // 추가: Map에서 Event 객체로 변환하는 팩토리 메서드
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'],
      description: map['description'],
      startTime: DateTime.parse(map['startTime']), // 문자열을 DateTime으로 변환
      endTime: DateTime.parse(map['endTime']), // 문자열을 DateTime으로 변환
      type: map['type'],
    );
  }
}
