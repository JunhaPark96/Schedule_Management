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
              _buildTextFormField('Name', _name, (value) => _name = value!),
              _buildTextFormField('Phone Number', _phoneNumber,
                  (value) => _phoneNumber = value!),
              _buildTextFormField(
                  'Fax Number', _faxNumber, (value) => _faxNumber = value!),
              _buildTextFormField('Email', _email, (value) => _email = value!),
              _buildTextFormField(
                  'Address', _address, (value) => _address = value!),
              _buildTextFormField('Organization', _organization,
                  (value) => _organization = value!),
              _buildTextFormField('Title', _title, (value) => _title = value!),
              _buildTextFormField('Role', _role, (value) => _role = value!),
              _buildTextFormField('Memo', _memo, (value) => _memo = value!),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.contactRepository.updateContact(
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
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      String label, String initialValue, Function(String?) onSave) {
    return Card(
      color: Colors.lightGreen[100],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextFormField(
          initialValue: initialValue,
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
