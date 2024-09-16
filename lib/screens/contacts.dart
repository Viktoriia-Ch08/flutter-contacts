import 'package:flutter/material.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:flutter_contacts/provider/contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Contacts extends ConsumerStatefulWidget {
  const Contacts({super.key, required this.onEdit, required this.onDelete});

  final void Function(Contact contact) onEdit;
  final void Function(String id) onDelete;

  @override
  ConsumerState<Contacts> createState() {
    return _ContactsState();
  }
}

class _ContactsState extends ConsumerState<Contacts> {
  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactsProvider);
    Widget content = Center(
      child: Text(
        'No contacts found',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );

    if (contacts.isNotEmpty) {
      content = ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (ctx, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.person_4_outlined),
            title: Text(contacts[i].name),
            subtitle: Text(contacts[i].phone),
            trailing:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 70,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => widget.onEdit(contacts[i]),
                      child: const Icon(Icons.edit),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () => widget.onDelete(contacts[i].id),
                      child: const Icon(Icons.delete),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      );
    }

    return content;
  }
}
