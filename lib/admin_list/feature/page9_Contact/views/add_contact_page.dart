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
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextFormField('Name', (value) => _name = value!),
              _buildTextFormField(
                  'Phone Number', (value) => _phoneNumber = value!),
              _buildTextFormField('Fax Number', (value) => _faxNumber = value!),
              _buildTextFormField('Email', (value) => _email = value!),
              _buildTextFormField('Address', (value) => _address = value!),
              _buildTextFormField(
                  'Organization', (value) => _organization = value!),
              _buildTextFormField('Title', (value) => _title = value!),
              _buildTextFormField('Role', (value) => _role = value!),
              _buildTextFormField('Memo', (value) => _memo = value!),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
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
                child: const Text(
                  'Add Contact',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, Function(String?) onSave) {
    return Card(
      color: Colors.lightGreen[100],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.green),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
          onSaved: onSave,
          validator: (value) => value!.isEmpty ? 'Enter $label' : null,
        ),
      ),
    );
  }
}
