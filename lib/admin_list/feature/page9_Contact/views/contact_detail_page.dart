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
        title: Text('${contact.name} ${contact.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditContactPage(
                    contact: contact,
                    contactRepository: contactRepository,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              /* Array ver */
              //contactRepository.removeContact(contact);
              contactRepository.removeContact(contact.id);
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
            _buildContactInfoRow(Icons.phone, 'Phone', contact.phoneNumber),
            _buildContactInfoRow(Icons.print, 'Fax', contact.faxNumber),
            _buildContactInfoRow(Icons.email, 'Email', contact.email),
            _buildContactInfoRow(Icons.home, 'Address', contact.address),
            _buildContactInfoRow(
                Icons.business, 'Organization', contact.organization),
            _buildContactInfoRow(Icons.badge, 'Title', contact.title),
            _buildContactInfoRow(Icons.people, 'Role', contact.role),
            _buildContactInfoRow(Icons.notes, 'Memo', contact.memo),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoRow(IconData icon, String label, String value) {
    return Card(
      color: Colors.lightGreen[100],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
