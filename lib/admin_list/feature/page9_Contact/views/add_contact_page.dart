import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import '../repos/contact_repository.dart';

class AddContactPage extends StatefulWidget {
  final ContactRepository contactRepository;

  const AddContactPage({super.key, required this.contactRepository});

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onSaved: (value) => _phoneNumber = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a phone number' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Fax Number'),
                onSaved: (value) => _faxNumber = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (value) => _address = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Organization'),
                onSaved: (value) => _organization = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Role'),
                onSaved: (value) => _role = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Memo'),
                onSaved: (value) => _memo = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.contactRepository.addContact(
                      Contact(
                        id: DateTime.now().millisecondsSinceEpoch,
                        name: _name,
                        phoneNumber: _phoneNumber,
                        faxNumber: _faxNumber,
                        email: _email,
                        address: _address,
                        organization: _organization,
                        title: _title,
                        role: _role,
                        memo: _memo,
                        createdAt: DateTime.now(),
                        modifiedAt: DateTime.now(),
                      ),
                    );
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
