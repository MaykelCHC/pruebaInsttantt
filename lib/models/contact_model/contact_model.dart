// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

ContactModel contactModelFromJson(String str) =>
    ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  final String? name;
  final String? contactId;

  ContactModel({
    this.name,
    this.contactId,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        name: json["name"],
        contactId: json["contact_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "contact_id": contactId,
      };
}
