import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/models/event_model.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/event_provider.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  int _id = 3;
  late String _title;
  late String _description;
  DateTime? _startTime;
  DateTime? _endTime;
  String _type = 'todo'; // 기본값 설정

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
              const SizedBox(height: 8.0),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(), // 테두리 추가
                    floatingLabelBehavior:
                        FloatingLabelBehavior.always, // 레이블을 항상 위에 고정
                  ),
                  maxLines: null, // 여러 줄 입력 가능
                  expands: true, // TextFormField가 남는 공간을 모두 채움
                  textAlignVertical: TextAlignVertical.top, // 입력 내용이 상단에서 시작
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _id++;
                    final newEvent = Event(
                      id: _id,
                      title: _title,
                      description: _description,
                      startTime: _startTime ?? DateTime.now(),
                      endTime:
                          _endTime ?? DateTime.now().add(Duration(hours: 1)),
                      type: _type,
                    );

                    // Consumer를 사용하여 EventProvider에 접근
                    context.read<EventProvider>().addEvent(newEvent);

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
