import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

/// Pantalla para gestionar los contactos del usuario.
class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContactProvider>(
      create: (context) => ContactProvider(),
      child: Consumer<ContactProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(provider),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddOrEditContact(context, provider),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  void _showAddOrEditContact(BuildContext context, ContactProvider provider,
      {ContactModel? contact}) {
    final nameController = TextEditingController(text: contact?.name ?? '');
    final idController =
        TextEditingController(text: contact?.idNumber?.toString() ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(contact == null ? 'Adicionar Contacto' : 'Editar Contacto'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MainTextFormField(
                  controller: nameController,
                  labelText: 'Nombre',
                  validator: Validators.contactNameValidator,
                  maxLength: 50,
                ),
                const SizedBox(height: 20),
                MainTextFormField(
                  controller: idController,
                  labelText: 'ID',
                  keyboardType: TextInputType.number,
                  validator: Validators.contactIdValidator,
                  maxLength: 10,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newContact = ContactModel(
                    name: nameController.text,
                    idNumber: int.tryParse(idController.text),
                    isAppContact: 1, // 6. Store as integer
                  );
                  if (contact == null) {
                    provider.addContact(newContact);
                  } else {
                    provider.updateContact(contact, newContact);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Mis Contactos'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _buildContent(ContactProvider provider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MainTextFormField(
            hintText: 'Buscar',
            prefixIcon: const Icon(Icons.search),
            onChanged: (value) {
              if (value.length > 3) {
                provider.searchContacts(value);
              } else {
                provider.clearSearch();
              }
            },
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _buildSectionHeader('Contactos de la Aplicación'),
              _buildContactList(provider.appContacts),
              _buildSectionHeader('Contactos del Dispositivo'),
              _buildDeviceContactList(provider.deviceContacts),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildContactList(List<ContactModel> contacts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          title: Text(contact.name ?? ''),
          subtitle: Text('ID: ${contact.idNumber}'),
          trailing: _buildContactActions(context, contact),
        );
      },
    );
  }

  Widget _buildDeviceContactList(List<Contact> contacts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          title: Text(contact.displayName),
          subtitle: Text(
              'Número: ${contact.phones.isNotEmpty ? contact.phones.first.number : 'No tiene'}'),
          trailing: _buildDeviceContactActions(context, contact),
        );
      },
    );
  }

  Widget _buildContactActions(BuildContext context, ContactModel contact) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Llama al método para editar el contacto de la aplicación.
            _showAddOrEditContact(
                context, Provider.of<ContactProvider>(context, listen: false),
                contact: contact);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // Llama al método para confirmar la eliminación del contacto.
            _confirmDeleteContact(context,
                Provider.of<ContactProvider>(context, listen: false), contact);
          },
        ),
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            // Llama al método para guardar el contacto en el dispositivo.
            _confirmSaveContactToDevice(context,
                Provider.of<ContactProvider>(context, listen: false), contact);
          },
        ),
      ],
    );
  }

  Widget _buildDeviceContactActions(BuildContext context, Contact contact) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // 7. Improve error handling and context understanding
            _editDeviceContact(context, contact);
          },
        ),
      ],
    );
  }

  Future<bool> _requestContactPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      return true;
    }
    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.contacts.request();
      return status.isGranted;
    }
    return false;
  }

  void _editDeviceContact(BuildContext context, Contact contact) async {
    bool permissionGranted = await _requestContactPermission();
    if (!permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permisos no otorgados')),
      );
      return;
    }

    // Fetch all contacts to find the specific one
    List<Contact> contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: false,
    );

    Contact? existingContact = contacts.firstWhere(
      (c) =>
          c.displayName.toLowerCase() == contact.displayName.toLowerCase() ||
          (c.phones.isNotEmpty &&
              c.phones.first.number == contact.phones.first.number),
    );

    _showEditDeviceContactDialog(context, existingContact);
  }

  void _showEditDeviceContactDialog(BuildContext context, Contact contact) {
    final nameController = TextEditingController(text: contact.name.first);
    final idController = TextEditingController(
        text: contact.phones.isNotEmpty ? contact.phones.first.number : '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Contacto'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MainTextFormField(
                  controller: nameController,
                  labelText: 'Nombre',
                  validator: Validators.contactNameValidator,
                  maxLength: 50,
                ),
                const SizedBox(height: 20),
                MainTextFormField(
                  controller: idController,
                  labelText: 'ID',
                  keyboardType: TextInputType.number,
                  validator: Validators.contactIdValidator,
                  maxLength: 10,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  contact.name.first = nameController.text;
                  if (contact.phones.isNotEmpty) {
                    contact.phones.first.number = idController.text;
                  } else {
                    contact.phones.add(Phone(idController.text));
                  }
                  contact.update();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contacto actualizado')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteContact(
      BuildContext context, ContactProvider provider, ContactModel contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Contacto'),
          content: const Text('¿Estás seguro de eliminar este contacto?'),
          actions: [
            TextButton(
              onPressed: () {
                provider.deleteContact(contact);
                Navigator.pop(context);
              },
              child: const Text('Eliminar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmSaveContactToDevice(
      BuildContext context, ContactProvider provider, ContactModel contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Guardar Contacto'),
          content:
              const Text('¿Quieres guardar este contacto en el dispositivo?'),
          actions: [
            TextButton(
              onPressed: () async {
                if (await _requestContactPermission()) {
                  Contact newContact = Contact(
                    name: Name(first: contact.name ?? ''),
                    phones: [Phone(contact.idNumber.toString())],
                  );
                  await newContact.insert();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contacto guardado')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
