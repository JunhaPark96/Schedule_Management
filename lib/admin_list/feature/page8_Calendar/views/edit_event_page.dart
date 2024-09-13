import 'package:flutter/material.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/models/event_model.dart';
import 'package:intl/intl.dart';

class EditEventPage extends StatefulWidget {
  final Event event;

  const EditEventPage({super.key, required this.event});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _startTime = widget.event.startTime;
    _endTime = widget.event.endTime;
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    DateTime initialDate =
        isStart ? (_startTime ?? DateTime.now()) : (_endTime ?? DateTime.now());
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (time != null) {
        setState(() {
          final selectedDateTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
          if (isStart) {
            _startTime = selectedDateTime;
          } else {
            _endTime = selectedDateTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final updatedEvent = widget.event.copyWith(
                title: _titleController.text,
                description: _descriptionController.text,
                startTime: _startTime ?? widget.event.startTime,
                endTime: _endTime ?? widget.event.endTime,
              );

              Navigator.pop(context, updatedEvent);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDateTime(context, true),
                    child: Text(
                      _startTime == null
                          ? 'Select Start Time'
                          : 'Start: ${DateFormat('yyyy-MM-dd HH:mm').format(_startTime!)}',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDateTime(context, false),
                    child: Text(
                      _endTime == null
                          ? 'Select End Time'
                          : 'End: ${DateFormat('yyyy-MM-dd HH:mm').format(_endTime!)}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
