import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_contacts/db/database.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:flutter_contacts/provider/contacts.dart';
import 'package:flutter_contacts/screens/contacts.dart';
import 'package:flutter_contacts/screens/new_contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tabs extends ConsumerStatefulWidget {
  const Tabs({super.key});

  @override
  ConsumerState<Tabs> createState() {
    return _TabsState();
  }
}

class _TabsState extends ConsumerState<Tabs> {
  String title = 'Contacts';
  int _selectedIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  void _changePage(i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  void _getContacts() async {
    setState(() {
      _isLoading = true;
    });
    final dbContacts = await databaseService.getContacts();
    ref.read(contactsProvider.notifier).getContact(dbContacts);
    setState(() {
      _isLoading = false;
    });
  }

  void _deleteContact(String id) async {
    ref.read(contactsProvider.notifier).deleteContact(id);
    databaseService.deleteContact(id);
  }

  void _editContact(Contact contact) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
            appBar: AppBar(
              title: const Text('Update contact'),
            ),
            body: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.7),
                Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ])),
              child: NewContact(
                contact: contact,
              ),
            ))));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Contacts(
      onEdit: _editContact,
      onDelete: _deleteContact,
    );

    if (_selectedIndex == 1) {
      content = const NewContact();
      title = 'New Contact';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white70),
        ),
        centerTitle: true,
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.4),
            Theme.of(context).colorScheme.primary.withOpacity(0.9)
          ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : content),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => _changePage(i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Contact')
          ]),
    );
  }
}
