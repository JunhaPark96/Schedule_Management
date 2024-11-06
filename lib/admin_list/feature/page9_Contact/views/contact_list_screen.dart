import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import '../repos/contact_repository.dart';
import 'add_contact_page.dart';
import 'contact_detail_page.dart';

class ContactListScreen extends StatefulWidget {
  final ContactRepository contactRepository;
  final String?
      initialSearchQuery; // eosl_info_widget - _buildSupplierRow에서 가져온 스트링

  const ContactListScreen(
      {super.key, required this.contactRepository, this.initialSearchQuery});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  int? _hoveredIndex;
  String _searchQuery = "";

  // 박준하 수정
  @override
  void initState() {
    super.initState();
    // 초기 검색어가 있다면 해당 검색어를 설정
    if (widget.initialSearchQuery != null) {
      _searchQuery = widget.initialSearchQuery!.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddContactPage(
                      contactRepository: widget.contactRepository),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase();
                  });
                },
                // 박준하 수정
                controller: TextEditingController(text: _searchQuery),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Contact>>(
                future: widget.contactRepository.fetchContacts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final contacts = snapshot.data!.where((contact) {
                    return contact.name.toLowerCase().contains(_searchQuery) ||
                        contact.phoneNumber.contains(_searchQuery) ||
                        contact.email.toLowerCase().contains(_searchQuery) ||
                        contact.organization
                            .toLowerCase()
                            .contains(_searchQuery) ||
                        contact.title.toLowerCase().contains(_searchQuery) ||
                        contact.role.toLowerCase().contains(_searchQuery);
                  }).toList();

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      final isHovered = _hoveredIndex == index;
                      return MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            _hoveredIndex = index;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _hoveredIndex = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: isHovered
                                ? Colors.green
                                : Colors.lightGreen[100],
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: isHovered
                                ? [
                                    const BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ]
                                : [],
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactDetailPage(
                                      contact: contact,
                                      contactRepository:
                                          widget.contactRepository),
                                ),
                              );
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    contact.organization,
                                    style: TextStyle(
                                      color: isHovered
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 19.2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '${contact.name} ${contact.title}',
                                    style: TextStyle(
                                      color: isHovered
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 19.2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Text(
                                    contact.role,
                                    style: TextStyle(
                                      color: isHovered
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16.8,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    contact.phoneNumber,
                                    style: TextStyle(
                                      color: isHovered
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16.8,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    contact.email,
                                    style: TextStyle(
                                      color: isHovered
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddContactPage(contactRepository: widget.contactRepository),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
