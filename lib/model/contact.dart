import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Contact {
  final String id;
  final String name;
  final String phone;

  Contact({required this.name, required this.phone, String? id})
      : id = id ?? uuid.v4();

  Map<String, dynamic> toMap() {
    return {'name': name, 'phone': phone, 'id': id};
  }

  factory Contact.fromMap(contact) {
    return Contact(
      name: contact['name'],
      phone: contact['phone'],
      id: contact['id'],
    );
  }
}

class ContactsList {
  List<Contact> contacts;

  ContactsList({required this.contacts});

  factory ContactsList.fromMap(contacts) {
    final contactsList = contacts.map((contact) => Contact.fromMap(contact));
    contacts = contactsList;
    return contacts;
  }
}
