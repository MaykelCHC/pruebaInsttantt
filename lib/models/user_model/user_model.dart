// Para convertir este JSON en un objeto UserModel, hacer lo siguiente:
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

/// Función para convertir una cadena JSON en un objeto UserModel.
UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

/// Función para convertir un objeto UserModel en una cadena JSON.
String userModelToJson(UserModel data) => json.encode(data.toJson());

/// Modelo de datos que representa un usuario.
class UserModel {
  /// Nombre de usuario.
  final String? username;

  /// Correo electrónico del usuario.
  final String? email;

  /// Contraseña del usuario.
  final String? password;

  /// Constructor de la clase UserModel.
  UserModel({
    this.username,
    this.email,
    this.password,
  });

  /// Crea una instancia de UserModel a partir de un mapa JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        username: json["username"],
        email: json["email"],
        password: json["password"],
      );

  /// Convierte una instancia de UserModel en un mapa JSON.
  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
      };
}
