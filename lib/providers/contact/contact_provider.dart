import 'package:flutter/material.dart';
import 'package:prueba_insttantt/models/contact_model/contact_model.dart';

import '../../services/services.dart';

class ContactProvider extends ChangeNotifier {
  List<ContactModel> _contacts = [];
  List<ContactModel> _allContacts = [];

  List<ContactModel> get contacts => _contacts;

  Future<void> loadContacts() async {
    final db = await DatabaseService().database;

    final result = await db.query('contacts');

    _allContacts = result
        .map(
          (c) => ContactModel(
            name: c['name']?.toString(),
            contactId: c['idNumber']?.toString(),
          ),
        )
        .toList();
    _contacts = _allContacts;
    notifyListeners();
  }

  Future<void> addContact(ContactModel contact) async {
    final db = await DatabaseService().database;

    await db.insert('contacts', contact.toJson());
    _allContacts.add(contact);
    _contacts.add(contact);
    notifyListeners();
  }

  void searchContacts(String query) {
    _contacts = _allContacts
        .where((contact) =>
            contact.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
    notifyListeners();
  }

  void clearSearch() {
    _contacts = _allContacts;
    notifyListeners();
  }
}
