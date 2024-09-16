import 'package:flutter_contacts/model/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactsNotifier extends StateNotifier<List<Contact>> {
  ContactsNotifier() : super([]);

  void getContact(List<Contact> contacts) {
    state = contacts;
  }

  void addContact(Contact contact) {
    state = [...state, contact];
  }

  void deleteContact(String id) {
    state = [...state.where((contact) => contact.id != id)];
  }

  void editContact(Contact contact) {
    state = [
      ...state.map((cont) {
        if (cont.id == contact.id) {
          return contact;
        }
        return cont;
      })
    ];
  }
}

final contactsProvider = StateNotifierProvider<ContactsNotifier, List<Contact>>(
    (ref) => ContactsNotifier());
