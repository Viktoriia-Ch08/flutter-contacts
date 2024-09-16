import 'package:flutter_contacts/model/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseService {
  Future<Database> getDB() async {
    final dir = await getDatabasesPath();
    final dbPath = path.join(dir, 'contacts.db');
    final db = await openDatabase(dbPath, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE contacts(id TEXT PRIMARY KEY, name TEXT, phone TEXT)');
    }, version: 1);
    return db;
  }

  Future<int> insert(Map<String, dynamic> contact) async {
    final db = await getDB();
    return await db.insert('contacts', contact);
  }

  Future<List<Contact>> getContacts() async {
    final db = await getDB();
    final allContacts = await db.query('contacts');
    List<Contact> contacts = [];

    allContacts.forEach((contact) => contacts.add(Contact.fromMap(contact)));

    return contacts;
  }

  void deleteContact(String id) async {
    final db = await getDB();
    await db.delete('contacts', where: 'id == ?', whereArgs: [id]);
  }

  void editContact(Map<String, dynamic> contact) async {
    final db = await getDB();
    await db.update('contacts', contact,
        where: 'id == ?', whereArgs: [contact['id']]);
  }
}

final databaseService = DatabaseService();
