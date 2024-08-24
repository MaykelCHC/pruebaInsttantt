import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/models.dart';
import '../../services/services.dart';

/// Proveedor para manejar la lista de contactos, con capacidades de carga, búsqueda y adición de contactos.
class ContactProvider extends ChangeNotifier {
  /// Lista privada que contiene los contactos filtrados (según una búsqueda).
  List<ContactModel> _contacts = [];

  /// Lista privada que contiene todos los contactos sin filtrar.
  List<ContactModel> _allContacts = [];

  // Lista de contactos de la aplicación.
  final List<ContactModel> _appContacts = [];

  // Lista de contactos del dispositivo.
  List<Contact> _deviceContacts = [];

  /// Obtiene la lista de contactos filtrados.
  List<ContactModel> get contacts => _contacts;

  // Obtener los contactos de la aplicación.
  List<ContactModel> get appContacts => _appContacts;

  // Obtener los contactos del dispositivo.
  List<Contact> get deviceContacts => _deviceContacts;

  bool _isLoading = false; // Estado de carga

  bool get isLoading => _isLoading; // Getter para el estado de carga

  /// Constructor que inicializa el proveedor y carga los contactos desde la base de datos.
  ContactProvider() {
    _requestContactPermission();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Solicita permisos para acceder a los contactos del dispositivo.
  Future<void> _requestContactPermission() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      isLoading = true;
      loadContacts();
      loadDeviceContacts();
      isLoading = false;
    } else {
      throw Exception('No tienes permisos concedidos');
    }
  }

  Future<void> loadDeviceContacts() async {
    if (await Permission.contacts.isGranted) {
      _deviceContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );
      notifyListeners();
    }
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
            idNumber: int.parse(c['idNumber']!.toString()),
          ),
        )
        .toList();

    // Inicialmente, los contactos filtrados son todos los contactos.
    _contacts = _allContacts;
    _appContacts.addAll(contacts);
    notifyListeners();
  }

  /// Método para agregar un nuevo contacto a la base de datos y actualizar la lista en memoria.
  void addContact(ContactModel contact) async {
    final db = await DatabaseService().database;

    // Inserta el nuevo contacto en la tabla 'contacts'.
    await db.insert('contacts', {
      'name': contact.name,
      'idNumber': contact.idNumber,
    });

    // Agrega el nuevo contacto a la lista de todos los contactos.
    _allContacts.add(contact);
    notifyListeners();
  }

  /// Método para buscar contactos en función de una cadena de consulta.
  Future<void> searchContacts(String query) async {
    isLoading = true;
    await Future.delayed(const Duration(milliseconds: 500));
    // Filter app contacts
    _contacts = _allContacts
        .where((contact) =>
            contact.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();

    // Filter device contacts
    _deviceContacts = deviceContacts
        .where((contact) =>
            contact.displayName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    isLoading = false;
    notifyListeners();
  }

  /// Método para limpiar la búsqueda y restaurar la lista completa de contactos.
  void clearSearch() {
    _contacts = _allContacts;
    notifyListeners();
  }

  void updateContact(ContactModel contact, ContactModel updatedContact) async {
    final db = await DatabaseService().database;

    // Actualiza el contacto en la base de datos.
    await db.update(
      'contacts',
      updatedContact.toJson(),
      where: 'idNumber = ?',
      whereArgs: [contact.idNumber],
    );

    // Encuentra el índice del contacto a actualizar en la lista local.
    final index =
        _allContacts.indexWhere((c) => c.idNumber == contact.idNumber);

    if (index != -1) {
      _allContacts[index] = updatedContact;
      _contacts = List.from(_allContacts);
      notifyListeners();
    }
  }

  void deleteContact(ContactModel contact) async {
    final db = await DatabaseService().database;

    // Elimina el contacto de la base de datos.
    await db.delete(
      'contacts',
      where: 'idNumber = ?',
      whereArgs: [contact.idNumber],
    );

    // Elimina el contacto de la lista local.
    _allContacts.removeWhere((c) => c.idNumber == contact.idNumber);
    _contacts = List.from(_allContacts);
    notifyListeners();
  }

  void saveContactToDevice(ContactModel contact) async {
    // Solicitar permiso para acceder a los contactos
    if (await FlutterContacts.requestPermission()) {
      // Insert new contact
      final newContact = Contact()
        ..name.first = contact.name!
        ..phones = [Phone('${contact.idNumber}')];

      try {
        // Insertar el nuevo contacto en el dispositivo
        await newContact.insert();

        // Opcional: Recargar la lista de contactos después de guardar
        loadContacts();

        print('Contacto guardado correctamente');
      } catch (e) {
        // Manejar errores durante la inserción del contacto
        print('Error al guardar el contacto: $e');
      }
    } else {
      // Manejar el caso donde los permisos no son otorgados
      print('Permisos no otorgados');
    }
    notifyListeners();
  }
}
