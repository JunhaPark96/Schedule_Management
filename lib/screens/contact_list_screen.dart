import 'package:flutter/material.dart';
import 'package:oneline/models/contact_model.dart';
import 'package:oneline/screens/add_contact_page.dart';
import 'package:oneline/screens/contact_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:oneline/models/contact_provider.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {},
            ),
          ),
          Expanded(
            child: Consumer<ContactProvider>(
              builder: (context, contactProvider, child) {
                final contacts = contactProvider.contacts;
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      title: Text(contact.name),
                      subtitle: Text(contact.phone),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ContactDetailPage(contact: contact),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
