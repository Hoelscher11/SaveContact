import 'package:flutter/material.dart';
import 'package:test_app/mvc_contacts/controller/contact_controller.dart';
import 'package:toast/toast.dart';

import '../model/contact_model.dart';

class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Contact> allContacts = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  ContactController contController = ContactController();
  bool isloading = true;

  void didChangeDependencies() async {
    allContacts = await contController.getAllContacts();
    setState(() {
      isloading = false;
    });
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: <Widget>[
          //Add Button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                allContacts = ContactController.addContact();
              });
            },
          ),
        ],
      ),
      body: (isloading == true)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: allContacts.length,
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                    title: Text(allContacts[index].name),
                    subtitle: Text(allContacts[index].phone),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.edit),
                      itemBuilder: (context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem(
                          value: 'Edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'),
                        )
                      ],
                      onSelected: (String value) {
                        switch (value) {
                          case 'Edit':
                            setState(() {
                              nameController.text = allContacts[index].name;
                              numberController.text = allContacts[index].phone;
                            });
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Edit Contact'),
                                    content: SizedBox(
                                      height: 150,
                                      child: Column(
                                        children: <Widget>[
                                          TextField(
                                            controller: nameController,
                                            // onChanged: (v) =>
                                            //     nameController.text = v,
                                            decoration: const InputDecoration(
                                                hintText: 'Name'),
                                          ),
                                          TextField(
                                            controller: numberController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                hintText: 'Phone Number'),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              RaisedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Close'),
                                              ),
                                              RaisedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    ContactController
                                                        .updateContact(
                                                            index,
                                                            nameController.text,
                                                            numberController
                                                                .text);
                                                    Toast.show(
                                                        "Contact Updated",
                                                        duration:
                                                            Toast.lengthLong,
                                                        gravity: Toast.bottom);
                                                  });
                                                },
                                                color: Colors.blue,
                                                child: const Text(
                                                  'Update',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                            break;
                          case 'Delete':
                            setState(() {
                              allContacts =
                                  ContactController.deleteContact(index);
                            });
                            break;
                          default:
                        }
                      },
                    ));
              }),
    );
  }
}
