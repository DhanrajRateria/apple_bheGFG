import 'package:flutter/material.dart';
import 'package:apple_bhe/image_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;

class Personnel extends StatefulWidget {
  static const String id = 'personnel';

  @override
  State<Personnel> createState() => _PersonnelState();
}

class _PersonnelState extends State<Personnel> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Team"),
        centerTitle: true,
      ),
      body: Center(
        child: ImageButton(
          imagename: "dhanraj",
          title: "Dhanraj Rateria",
          desc: "Founder & CEO",
          
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Add Person"),
                      content: Column(children: [
                        TextField(
                          controller: _controller1,
                          decoration: InputDecoration(labelText: "Enter Name"),
                        ),
                        TextField(
                          controller: _controller2,
                          decoration:
                              InputDecoration(labelText: "Enter Designation"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedFile = await ImagePicker().pickImage(
                              source:
                                  ImageSource.gallery, // or ImageSource.camera
                            );
                            if (pickedFile != null) {
                              setState(() {
                                _image = XFile(pickedFile.path);
                              });
                            }
                          },
                          child: Text('Pick Image'),
                        ),
                      ]),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final personnel =
                                  await _firestore.collection('personnel').add({
                                'Name': _controller1.text,
                                'Designation': _controller2.text,
                              });
                              if (personnel != null) {
                                Navigator.pushNamed(context, Personnel.id);
                              }
                            } catch (e) {
                              print(e);
                            }
                            setState(() {});
                            Navigator.of(context).pop();
                            _controller1.clear();
                            _controller2.clear();
                          },
                          child: Text('Add'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _controller1.clear();
                            _controller2.clear();
                          },
                          child: Text('Cancel'),
                        ),
                      ]);
                });
          }),
    );
  }
}
