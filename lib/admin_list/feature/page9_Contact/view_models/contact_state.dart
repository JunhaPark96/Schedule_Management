import 'package:oneline2/admin_list/feature/page9_Contact/models/contact_model.dart';

class ContactState {
  final List<Contact> contactList;
  final List<Contact> filteredList;
  String? selectedCategory;

  ContactState({
    required this.contactList,
    this.selectedCategory,
    required this.filteredList,
  });

  ContactState copyWith({
    List<Contact>? contactList,
    List<Contact>? filteredList,
    String? selectedCategory,
  }) {
    return ContactState(
      contactList: contactList ?? this.contactList,
      filteredList: filteredList ?? this.filteredList,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
