import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_insttantt/models/models.dart';
import 'package:prueba_insttantt/widgets/widgets.dart';

import '../../providers/providers.dart';
import '../../utils/utils.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContactProvider>(
      create: (_) => ContactProvider(),
      child: Consumer<ContactProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mis Contactos'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
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
                  child: ListView.builder(
                    itemCount: provider.contacts.length,
                    itemBuilder: (context, index) {
                      final contact = provider.contacts[index];
                      return ListTile(
                        title: Text(contact.name ?? ''),
                        subtitle: Text('ID: ${contact.contactId}'),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showAddContactForm(context, provider);
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  void _showAddContactForm(BuildContext context, ContactProvider provider) {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Contacto'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MainTextFormField(
                  controller: nameController,
                  labelText: 'Nombre',
                  validator: Validators.contactNameValidator,
                ),
                const SizedBox(
                  height: 20,
                ),
                MainTextFormField(
                  controller: idController,
                  labelText: 'ID',
                  keyboardType: TextInputType.number,
                  validator: Validators.contactIdValidator,
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
                    contactId: idController.text,
                  );
                  provider.addContact(newContact);
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
