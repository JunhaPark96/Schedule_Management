import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 나타날 때 쓰는 패키지 추가
import 'package:oneline/screens/add_event_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:oneline/models/event_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            // 해당 일에 스케줄 있으면 초록색 표시하는 부분
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  bool isSelectedDay = isSameDay(day, _selectedDay);
                  return Positioned(
                    top: isSelectedDay ? 10 : 5,
                    left: isSelectedDay ? 10 : 5,
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            eventLoader: (day) {
              return Provider.of<EventProvider>(context, listen: false)
                  .getEventsForDay(day);
            },
          ),
          const SizedBox(height: 8.0),
          Consumer<EventProvider>(
            builder: (context, eventProvider, child) {
              final events = eventProvider.getEventsForDay(_selectedDay);
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(_selectedDay);
              return Container(
                color: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected Day: $formattedDate',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    Text(
                      'Tasks: ${events.length}',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: Consumer<EventProvider>(
              builder: (context, eventProvider, child) {
                final events = eventProvider.getEventsForDay(_selectedDay);
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10.0),
                          title: Text(
                            event.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} - ${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}',
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
