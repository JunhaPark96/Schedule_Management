import 'package:flutter/material.dart';
import 'package:oneline/models/contact_model.dart';
import 'package:provider/provider.dart';
import 'package:oneline/models/contact_provider.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phone;
  late String _email;
  late String _workplace; // 20240716_김재영 : 연락처 내 직장정보 추가
  late String _notes; // 20240716_김재영 : 연락처 내 메모 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Workplace'), // 20240716_김재영 : 연락처 내 직장정보 추가
                onSaved: (value) {
                  _workplace = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Notes'), // 20240716_김재영 : 연락처 내 메모 추가
                onSaved: (value) {
                  _notes = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newContact = Contact(
                      name: _name,
                      phone: _phone,
                      email: _email,
                      workplace: _workplace, // 20240716_김재영 : 연락처 내 직장정보 추가
                      notes: _notes, // 20240716_김재영 : 연락처 내 메모 추가
                    );
                    Provider.of<ContactProvider>(context, listen: false)
                        .addContact(
                            newContact); // 20240716_김재영 : ContactProvider 구현
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
