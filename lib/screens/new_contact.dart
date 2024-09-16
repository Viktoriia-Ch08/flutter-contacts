import 'package:flutter/material.dart';
import 'package:flutter_contacts/db/database.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:flutter_contacts/provider/contacts.dart';
import 'package:flutter_contacts/screens/tabs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewContact extends ConsumerStatefulWidget {
  const NewContact({super.key, this.contact});
  final Contact? contact;

  @override
  ConsumerState<NewContact> createState() {
    return _NewContactState();
  }
}

class _NewContactState extends ConsumerState<NewContact> {
  final _formKey = GlobalKey<FormState>();
  String? _enteredName;
  String? _enteredPhone;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _enteredName = widget.contact!.name;
      _enteredPhone = widget.contact!.phone;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (widget.contact != null) {
          ref.read(contactsProvider.notifier).editContact(Contact(
              name: _enteredName!,
              phone: _enteredPhone!,
              id: widget.contact!.id));
          databaseService.editContact(Contact(
                  name: _enteredName!,
                  phone: _enteredPhone!,
                  id: widget.contact!.id)
              .toMap());
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You have updated the contact')));
          Navigator.of(context).pop();

          return;
        }

        databaseService.insert(
            Contact(name: _enteredName!, phone: _enteredPhone!).toMap());

        ref
            .read(contactsProvider.notifier)
            .addContact(Contact(name: _enteredName!, phone: _enteredPhone!));

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You have added the contact')));

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (ctx) => const Tabs()));
      } catch (err) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err.toString())));
      }
    }
  }

  void _cancel() {
    if (widget.contact != null) {
      Navigator.of(context).pop();
      return;
    }
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _enteredName,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Allan Po',
                    helperText: 'Write contact`s name...',
                    prefixIcon: const Icon(Icons.person_4_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write correct name.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredName = newValue;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: _enteredPhone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    hintText: '+380(##)###-##-##',
                    helperText: 'Write contact`s phone...',
                    prefixIcon: const Icon(Icons.phone_android),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('+380')) {
                      return 'Write correct phone +380(##)###-##-##.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredPhone = newValue;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: _cancel, child: const Text('Cancel')),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(onPressed: _save, child: const Text('Save'))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
