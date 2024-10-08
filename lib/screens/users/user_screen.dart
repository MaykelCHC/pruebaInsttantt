import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../screens.dart';

/// Pantalla de usuario que muestra el perfil del usuario y permite añadir o editar el avatar.
class UserScreen extends StatelessWidget {
  /// Modelo de usuario pasado a la pantalla.
  final UserModel? userModel;

  /// Constructor de la pantalla de usuario.
  const UserScreen({super.key, this.userModel});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SigninProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${userModel?.username ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              provider
                  .logout(); // Llama al método de cierre de sesión en el proveedor.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SigninScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Selector<SigninProvider, File?>(
              selector: (context, provider) => provider.image,
              builder: (context, image, child) {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: image != null
                      ? FileImage(image)
                      : const AssetImage(AppImages.avatar),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showImageSourceActionSheet(context, provider),
              child: const Text('Adicionar/Editar Avatar'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Usuario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacto',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserScreen(),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactsScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  /// Muestra una hoja de acción para seleccionar la fuente de la imagen del avatar.
  void _showImageSourceActionSheet(
      BuildContext context, SigninProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Tomar una foto'),
                onTap: () {
                  Navigator.pop(context);
                  provider.pickImage(ImageSource
                      .camera); // Llama al método para seleccionar imagen desde la cámara.
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Cargar desde Galeria'),
                onTap: () {
                  Navigator.pop(context);
                  provider.pickImage(ImageSource
                      .gallery); // Llama al método para seleccionar imagen desde la galería.
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
