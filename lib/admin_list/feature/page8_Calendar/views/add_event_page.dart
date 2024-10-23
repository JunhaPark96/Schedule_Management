import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_bloc.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/models/event_model.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_event.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_state.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  final EoslDetailModel? eoslDetailModel;

  const AddEventPage({super.key, this.eoslDetailModel});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  int _id = 100; // 이벤트 ID 초기값
  late String _title = ''; // 타이틀 초기화
  late String _description = ''; // 설명 초기화
  DateTime? _startTime; // 시작 시간
  DateTime? _endTime; // 종료 시간
  String _type = 'todo'; // 기본 타입 설정

  @override
  void initState() {
    super.initState();

    if (widget.eoslDetailModel != null) {
      _title = '${widget.eoslDetailModel!.hostName} EOSL 만료일자';
      _description =
          ' - ${widget.eoslDetailModel!.field}\n - ${widget.eoslDetailModel!.note}\n - ${widget.eoslDetailModel!.supplier}';
      _type = 'eos';

      DateTime eoslDate = DateTime.parse(widget.eoslDetailModel!.eoslDate!);
      _startTime =
          DateTime(eoslDate.year, eoslDate.month, eoslDate.day, 0, 0); // 00:00
      _endTime = DateTime(
          eoslDate.year, eoslDate.month, eoslDate.day, 23, 59); // 23:59
    }
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
        title: const Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title, // 초기값 설정
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
              const SizedBox(height: 8.0),
              Expanded(
                child: TextFormField(
                  initialValue: _description, // 초기값 설정
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
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
                      endTime: _endTime ??
                          DateTime.now().add(const Duration(hours: 1)),
                      type: _type,
                    );

                    // BLoC을 사용하여 이벤트 추가
                    context.read<EventBloc>().add(AddEvent(newEvent));

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
