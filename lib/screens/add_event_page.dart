import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oneline/models/event_provider.dart';
import 'package:oneline/models/event_model.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  DateTime? _startTime;
  DateTime? _endTime;
  String _type = 'todo'; // 기본값 설정
  late String _targetPage;

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
        title: const Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Type'),
                value: _type,
                items: <String>['todo', 'schedule', 'eos'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _selectDateTime(context, true),
                      child: Text(
                        _startTime == null
                            ? 'Select Start Time'
                            : 'Start: ${_startTime.toString()}',
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
                            : 'End: ${_endTime.toString()}',
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newEvent = Event(
                      title: _title,
                      description: _description,
                      startTime: _startTime ?? DateTime.now(),
                      endTime:
                          _endTime ?? DateTime.now().add(Duration(hours: 1)),
                      type: _type,
                    );
                    Provider.of<EventProvider>(context, listen: false)
                        .addEvent(newEvent);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
