import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneline2/admin_list/feature/page9_Contact/models/contact_model.dart';
import 'package:oneline2/admin_list/feature/page9_Contact/repos/contact_repository.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc()
      : super(ContactState(
          contactList: [],
          filteredList: [],
          selectedCategory: null,
        )) {
    on<FetchContacts>(_onFetchContacts);
    on<AddContact>(_onAddContact);
    on<RemoveContact>(_onRemoveContact);
    on<ModifyContact>(_onModifyContact);
    on<FilterContacts>(_onFilterContacts);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onFetchContacts(
      FetchContacts event, Emitter<ContactState> emit) async {
    try {
      List<Contact> contactList = await ContactRepository().fetchContacts();

      emit(state.copyWith(
        contactList: contactList,
        filteredList: contactList,
      ));
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _onAddContact(
      AddContact event, Emitter<ContactState> emit) async {
    try {
      await ContactRepository().addContact(event.contact);
      final updatedList = List<Contact>.from(state.contactList)
        ..add(event.contact);

      emit(state.copyWith(
        contactList: updatedList,
        filteredList: updatedList,
      ));
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _onRemoveContact(
      RemoveContact event, Emitter<ContactState> emit) async {
    try {
      await ContactRepository().removeContact(event.contact);
      final updatedList = state.contactList
          .where((contact) => contact != event.contact)
          .toList();

      emit(state.copyWith(
        contactList: updatedList,
        filteredList: updatedList,
      ));
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _onModifyContact(
      ModifyContact event, Emitter<ContactState> emit) async {
    try {
      await ContactRepository().updateContact(event.contact);
      final updatedList = state.contactList.map((contact) {
        return contact.id == event.contact.id ? event.contact : contact;
      }).toList();

      emit(state.copyWith(
        contactList: updatedList,
        filteredList: updatedList,
      ));
    } catch (error) {
      print('Error: $error');
    }
  }

  void _onFilterContacts(FilterContacts event, Emitter<ContactState> emit) {
    final query = event.query.toLowerCase();
    if (query.isEmpty) {
      emit(state.copyWith(filteredList: state.contactList));
    } else {
      final filteredList = state.contactList.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
            contact.phoneNumber.contains(query) ||
            contact.email.toLowerCase().contains(query);
      }).toList();

      emit(state.copyWith(filteredList: filteredList));
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<ContactState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }
}
