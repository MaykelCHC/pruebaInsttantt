// Para convertir este JSON en un objeto ContactModel, hacer lo siguiente:
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

/// Función para convertir una cadena JSON en un objeto ContactModel.
ContactModel contactModelFromJson(String str) =>
    ContactModel.fromJson(json.decode(str));

/// Función para convertir un objeto ContactModel en una cadena JSON.
String contactModelToJson(ContactModel data) => json.encode(data.toJson());

/// Modelo de datos que representa un contacto.
class ContactModel {
  /// Nombre del contacto.
  final String? name;

  /// Identificador único del contacto.
  final String? contactId;

  /// Constructor de la clase ContactModel.
  ContactModel({
    this.name,
    this.contactId,
  });

  /// Crea una instancia de ContactModel a partir de un mapa JSON.
  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        name: json["name"],
        contactId: json["idNumber"],
      );

  /// Convierte una instancia de ContactModel en un mapa JSON.
  Map<String, dynamic> toJson() => {
        "name": name,
        "idNumber": contactId,
      };
}
