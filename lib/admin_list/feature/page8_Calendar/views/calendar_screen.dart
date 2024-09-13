import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/event_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
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
                if (events.isNotEmpty) {
                  bool isSelectedDay = isSameDay(day, _selectedDay);
                  return Positioned(
                    top: isSelectedDay ? 10 : 5,
                    left: isSelectedDay ? 10 : 5,
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
              final events = eventProvider
                  .getEventsForDay(_selectedDay)
                  .where((event) =>
                      _searchQuery.isEmpty ||
                      event.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                  .toList();
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
                final events = eventProvider
                    .getEventsForDay(_selectedDay)
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} - ${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              eventProvider.removeEvent(event);
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
                              eventProvider.updateEvent(updatedEvent);
                            }
                          },
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
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final results = eventProvider.getAllEvents().where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

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
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final suggestions = eventProvider.getAllEvents().where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

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
