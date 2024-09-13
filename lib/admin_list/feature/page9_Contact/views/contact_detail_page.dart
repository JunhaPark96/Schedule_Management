import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import '../repos/contact_repository.dart';
import 'edit_contact_page.dart';

class ContactDetailPage extends StatelessWidget {
  final Contact contact;
  final ContactRepository contactRepository;

  const ContactDetailPage({
    super.key,
    required this.contact,
    required this.contactRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditContactPage(
                      contact: contact, contactRepository: contactRepository),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              contactRepository.removeContact(contact);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: ${contact.phoneNumber}'),
            Text('Fax: ${contact.faxNumber}'),
            Text('Email: ${contact.email}'),
            Text('Address: ${contact.address}'),
            Text('Organization: ${contact.organization}'),
            Text('Title: ${contact.title}'),
            Text('Role: ${contact.role}'),
            Text('Memo: ${contact.memo}'),
          ],
        ),
      ),
    );
  }
}
