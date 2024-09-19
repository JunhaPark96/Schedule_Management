import 'package:oneline2/admin_list/feature/page9_Contact/models/contact_model.dart';

abstract class ContactEvent {}

class FetchContacts extends ContactEvent {}

class AddContact extends ContactEvent {
  final Contact contact;
  AddContact(this.contact);
}

class RemoveContact extends ContactEvent {
  final Contact contact;
  RemoveContact(this.contact);
}

class ModifyContact extends ContactEvent {
  final Contact contact;
  ModifyContact(this.contact);
}

class FilterContacts extends ContactEvent {
  final String query;
  FilterContacts(this.query);
}

class SelectCategory extends ContactEvent {
  final String category;
  SelectCategory(this.category);
}
