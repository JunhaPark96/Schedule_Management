/*일 별 시간대별로 보는 페이지 > 지금 사용 x */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oneline/models/event_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
            DayViewPage(selectedDay: DateTime.now()), // 임시로 DayViewPage를 홈으로 설정
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        ),
      ),
    );
  }
}

class DayViewPage extends StatelessWidget {
  final DateTime selectedDay;

  const DayViewPage({Key? key, required this.selectedDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily ${selectedDay.toLocal()}'.split(' ')[0]),
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          final events = eventProvider.getEventsForDay(selectedDay).toList()
            ..sort((a, b) => a.startTime.compareTo(b.startTime));

          if (events.isEmpty) {
            return Center(
              child: Text('등록된 일정이 없습니다.'),
            );
          }

          return ListView.builder(
            itemCount: 24,
            itemExtent: 60,
            itemBuilder: (context, index) {
              final overlappingEvents = events.where((event) {
                final startHour = event.startTime.hour;
                final endHour = event.endTime.hour;
                return index >= startHour && index < endHour;
              }).toList();

              return Stack(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(
                            '${index.toString().padLeft(2, '0')}:00',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...overlappingEvents.map((event) {
                    final startHour = event.startTime.hour;
                    final endHour = event.endTime.hour;
                    final startMinute = event.startTime.minute;
                    final endMinute = event.endTime.minute;

                    final topPosition = (startHour * 60 + startMinute)
                        .toDouble(); // 시작 시간에 따른 위치 설정
                    final height = (endHour * 60 +
                            endMinute -
                            startHour * 60 -
                            startMinute)
                        .toDouble(); // 시간 길이에 따른 높이 설정

                    return Positioned(
                      top: topPosition,
                      left: 50, // 시간대 표시를 위한 왼쪽 여백
                      right: 10, // 오른쪽 여백
                      height: height,
                      child: GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                Colors.greenAccent.withOpacity(0.7), // 초록색으로 설정
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${event.title}\n${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')} - ${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
