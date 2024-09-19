import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import '../repos/contact_repository.dart';

class EditContactPage extends StatefulWidget {
  final Contact contact;
  final ContactRepository contactRepository;

  const EditContactPage({
    super.key,
    required this.contact,
    required this.contactRepository,
  });

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name,
      _phoneNumber,
      _faxNumber,
      _email,
      _address,
      _organization,
      _title,
      _role,
      _memo;

  @override
  void initState() {
    super.initState();
    _name = widget.contact.name;
    _phoneNumber = widget.contact.phoneNumber;
    _faxNumber = widget.contact.faxNumber;
    _email = widget.contact.email;
    _address = widget.contact.address;
    _organization = widget.contact.organization;
    _title = widget.contact.title;
    _role = widget.contact.role;
    _memo = widget.contact.memo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onSaved: (value) => _phoneNumber = value!,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.contactRepository.addContact(
                      Contact(
                        id: widget.contact.id,
                        name: _name,
                        phoneNumber: _phoneNumber,
                        faxNumber: _faxNumber,
                        email: _email,
                        address: _address,
                        organization: _organization,
                        title: _title,
                        role: _role,
                        memo: _memo,
                        createdAt: widget.contact.createdAt,
                        modifiedAt: DateTime.now(),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
