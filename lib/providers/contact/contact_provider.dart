import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/services.dart';

/// Proveedor para manejar la lista de contactos, con capacidades de carga, búsqueda y adición de contactos.
class ContactProvider extends ChangeNotifier {
  /// Lista privada que contiene los contactos filtrados (según una búsqueda).
  List<ContactModel> _contacts = [];

  /// Lista privada que contiene todos los contactos sin filtrar.
  List<ContactModel> _allContacts = [];

  /// Obtiene la lista de contactos filtrados.
  List<ContactModel> get contacts => _contacts;

  /// Constructor que inicializa el proveedor y carga los contactos desde la base de datos.
  ContactProvider() {
    loadContacts();
  }

  /// Método asíncrono para cargar los contactos desde la base de datos.
  Future<void> loadContacts() async {
    final db = await DatabaseService().database;

    // Consulta todos los registros de la tabla 'contacts'.
    final result = await db.query('contacts');

    // Convierte los resultados de la consulta en una lista de objetos ContactModel.
    _allContacts = result
        .map(
          (c) => ContactModel(
            name: c['name']?.toString(),
            contactId: c['contactId']?.toString(),
          ),
        )
        .toList();

    // Inicialmente, los contactos filtrados son todos los contactos.
    _contacts = _allContacts;
    notifyListeners();
  }

  /// Método para agregar un nuevo contacto a la base de datos y actualizar la lista en memoria.
  void addContact(ContactModel contact) async {
    final db = await DatabaseService().database;

    // Inserta el nuevo contacto en la tabla 'contacts'.
    await db.insert('contacts', {
      'name': contact.name,
      'idNumber': contact.contactId,
    });

    // Agrega el nuevo contacto a la lista de todos los contactos.
    _allContacts.add(contact);
    notifyListeners();
  }

  /// Método para buscar contactos en función de una cadena de consulta.
  void searchContacts(String query) {
    _contacts = _allContacts
        .where((contact) =>
            contact.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
    notifyListeners();
  }

  /// Método para limpiar la búsqueda y restaurar la lista completa de contactos.
  void clearSearch() {
    _contacts = _allContacts;
    notifyListeners();
  }
}
