import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // BlocBuilder를 사용하기 위해 추가
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_bloc.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/models/event_model.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_event.dart'; // EventBloc으로 변경
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_state.dart';
import 'edit_event_page.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      // BlocBuilder로 변경
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Event Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final updatedEvent = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEventPage(event: event),
                    ),
                  );
                  if (updatedEvent != null && updatedEvent is Event) {
                    context
                        .read<EventBloc>()
                        .add(RemoveEvent(event.id)); // eventProvider -> Bloc 사용
                    context.read<EventBloc>().add(
                        AddEvent(updatedEvent)); // eventProvider -> Bloc 사용
                    Navigator.pop(context, updatedEvent);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('삭제'),
                      content: const Text('정말 삭제 하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<EventBloc>().add(RemoveEvent(
                                event.id)); // eventProvider -> Bloc 사용
                            Navigator.pop(context); // Close the dialog
                            Navigator.pop(context); // Close the EventDetailPage
                          },
                          child: const Text('삭제'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title 크기 더 크게
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 32.0, // 크기 더 키움
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0), // 간격을 더 넓힘
                // Start Time, End Time 회색 및 볼드 처리
                Text(
                  'Start Time: ${DateFormat.jm().format(event.startTime)}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey, // 회색 처리
                  ),
                ),
                Text(
                  'End Time: ${DateFormat.jm().format(event.endTime)}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey, // 회색 처리
                  ),
                ),
                const SizedBox(height: 16.0), // Description과 시간 사이 간격
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0), // Description 아래 한 줄 띄움
                Text(
                  event.description,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
