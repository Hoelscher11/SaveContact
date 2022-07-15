import 'package:flutter/material.dart';
import 'package:test_app/mvc_contacts/view/list_screen.dart';
import 'package:test_app/sql/database.dart';

import '../model/contact_model.dart';

class ContactController {
  DBProvider db = DBProvider();
  static List<Contact> allContacts = [];

  List<Contact> getAllContacts() {
    allContacts = contactList;
    return allContacts;
  }

  static List<Contact> addContact() {
    allContacts.add(Contact(name: 'Alex', phone: '0159434335'));
    return allContacts;
  }

  static List<Contact> deleteContact(int index) {
    allContacts.removeAt(index);
    return allContacts;
  }

  static void updateContact(int index, String name, String number) {
    allContacts[index].name = name;
    allContacts[index].phone = number;
  }
}
