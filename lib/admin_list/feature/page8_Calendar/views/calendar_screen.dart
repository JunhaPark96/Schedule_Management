import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_bloc.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/models/event_model.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_event.dart'; // EventBloc으로 변경
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_state.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/views/add_event_page.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/views/edit_event_page.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Set<DateTime> _eventDays = {}; // 이벤트가 있는 날짜를 저장할 Set

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });

    context.read<EventBloc>().add(LoadEvents());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EventSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              context.read<EventBloc>().add(LoadEvents());
            },
            onFormatChanged: (format) {
              setState(() {
                calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                final eventBlocState = context.watch<EventBloc>().state;
                if (eventBlocState is EventLoadSuccess) {
                  final dayEvents = eventBlocState.events.where((event) {
                    return day.isAtSameMomentAs(event.startTime) ||
                        (day.isAfter(event.startTime) &&
                            day.isBefore(event.endTime)) ||
                        day.isAtSameMomentAs(event.endTime);
                  }).toList();

                  if (dayEvents.isNotEmpty) {
                    return Positioned(
                      bottom: 4,
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                }
                return null;
              },
            ),
            eventLoader: (day) {
              final state = context.watch<EventBloc>().state;
              if (state is EventLoadSuccess) {
                return state.events.where((event) {
                  final startDate = event.startTime;
                  final endDate = event.endTime;

                  // 이벤트의 시작과 끝 날짜가 같은 경우
                  if (isSameDay(day, startDate) || isSameDay(day, endDate)) {
                    return true;
                  }

                  // 이벤트의 기간이 해당 날짜를 포함하는 경우
                  return (day.isAfter(startDate) && day.isBefore(endDate)) ||
                      (isSameDay(day, startDate) || isSameDay(day, endDate));
                }).toList();
              }
              return [];
            },
          ),
          const SizedBox(height: 8.0),
          BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              if (state is EventLoadSuccess) {
                final events = state.events
                    .where((event) {
                      final eventStart = event.startTime;
                      final eventEnd = event.endTime;

                      // selectedDay의 시작과 종료 범위 설정
                      final startOfSelectedDay = DateTime(
                        _selectedDay.year,
                        _selectedDay.month,
                        _selectedDay.day,
                      );
                      final endOfSelectedDay = DateTime(
                          _selectedDay.year,
                          _selectedDay.month,
                          _selectedDay.day,
                          23,
                          59,
                          59,
                          999);

                      // 이벤트가 선택된 날짜 범위와 겹치는지 확인
                      final isWithinRange = eventStart.isBefore(endOfSelectedDay
                              .add(Duration(milliseconds: 1))) &&
                          eventEnd.isAfter(startOfSelectedDay
                              .subtract(Duration(milliseconds: 1)));

                      print(
                          'Event: ${event.title}, Start: $eventStart, End: $eventEnd, Selected Day Start: $startOfSelectedDay, Selected Day End: $endOfSelectedDay, Is Within Range: $isWithinRange');

                      return isWithinRange;
                    })
                    .where((event) =>
                        _searchQuery.isEmpty ||
                        event.title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                    .toList();
                print(
                    'Selected Day: $_selectedDay, Events for the day: $events');
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(_selectedDay);
                return Container(
                  color: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Day: $formattedDate',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16.0),
                      ),
                      Text(
                        'Tasks: ${events.length}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16.0),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventLoadSuccess) {
                  final events = state.events
                      .where((event) {
                        final eventStart = event.startTime;
                        final eventEnd = event.endTime;

                        // 선택된 날짜의 시작과 종료 범위 설정
                        final startOfSelectedDay = DateTime(
                          _selectedDay.year,
                          _selectedDay.month,
                          _selectedDay.day,
                        );
                        final endOfSelectedDay = DateTime(
                          _selectedDay.year,
                          _selectedDay.month,
                          _selectedDay.day,
                          23,
                          59,
                          59,
                          999,
                        );

                        // 로그 찍기: 선택된 날짜 범위
                        print('Selected Day Start: $startOfSelectedDay');
                        print('Selected Day End: $endOfSelectedDay');

                        // 이벤트의 시작과 끝 시간이 선택된 날짜 범위와 겹치는지 확인
                        final isStartWithinRange = eventStart.isBefore(
                                endOfSelectedDay
                                    .add(Duration(milliseconds: 1))) &&
                            eventStart.isAfter(startOfSelectedDay
                                .subtract(Duration(milliseconds: 1)));
                        final isEndWithinRange = eventEnd.isAfter(
                                startOfSelectedDay
                                    .subtract(Duration(milliseconds: 1))) &&
                            eventEnd.isBefore(endOfSelectedDay
                                .add(Duration(milliseconds: 1)));

                        // 로그 찍기: 이벤트 시작 및 끝 날짜
                        print('Event Start: $eventStart');
                        print('Event End: $eventEnd');
                        print('Is Start Within Range: $isStartWithinRange');
                        print('Is End Within Range: $isEndWithinRange');

                        // 선택된 날짜 범위와 겹치는지 확인
                        final isWithinRange = isStartWithinRange ||
                            isEndWithinRange ||
                            (eventStart.isBefore(startOfSelectedDay) &&
                                eventEnd.isAfter(endOfSelectedDay));

                        // 로그 찍기: 최종 결과
                        print('Is Within Range: $isWithinRange');

                        return isWithinRange;
                      })
                      .where((event) =>
                          _searchQuery.isEmpty ||
                          event.title
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                      .toList();
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} - ${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                context
                                    .read<EventBloc>()
                                    .add(RemoveEvent(event.id));
                              },
                            ),
                            onTap: () async {
                              final updatedEvent = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditEventPage(event: event),
                                ),
                              );

                              if (updatedEvent != null) {
                                context
                                    .read<EventBloc>()
                                    .add(UpdateEvent(updatedEvent));
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
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

class EventSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final eventBlocState = context.watch<EventBloc>().state;
    List<Event> results = [];

    if (eventBlocState is EventLoadSuccess) {
      results = eventBlocState.events.where((event) {
        return event.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final event = results[index];
        return ListTile(
          title: Text(event.title),
          subtitle: Text(
            '${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} - ${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditEventPage(event: event),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final eventBlocState = context.watch<EventBloc>().state;
    List<Event> suggestions = [];

    if (eventBlocState is EventLoadSuccess) {
      suggestions = eventBlocState.events.where((event) {
        return event.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final event = suggestions[index];
        return ListTile(
          title: Text(event.title),
          onTap: () {
            close(context, event.title);
          },
        );
      },
    );
  }
}
