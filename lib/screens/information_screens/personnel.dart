import 'dart:io';

import 'package:flutter/material.dart';
import 'package:apple_bhe/image_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
final _storage = FirebaseStorage.instance;

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

  Future<String?> _uploadImage(File file) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      }

      final ref = _storage
          .ref()
          .child('personnel')
          .child(user.uid)
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Team"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('personnel').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final personnelList = snapshot.data!.docs
              .map((doc) => doc.data()! as Map<String, dynamic>)
              .toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: personnelList.length,
            itemBuilder: (context, index) {
              final personnel = personnelList[index] as Map<String, dynamic>;

              final name = personnel['Name'];
              final designation = personnel['Designation'];
              final imageUrl = personnel['ImageUrl'];

              return ImageButton(
                imagename: imageUrl ?? "",
                title: name ?? "",
                desc: designation ?? "",
              );
            },
          );
        },
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
                        SizedBox(
                          height: 50,
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
                              final imageUrl =
                                  await _uploadImage(File(_image!.path));
                              final name = _controller1.text.trim();
                              final designation = _controller2.text.trim();
                              if (name.isEmpty ||
                                  designation.isEmpty ||
                                  imageUrl == null) {
                                return;
                              }
                              await _firestore.collection('personnel').add({
                                'Name': name,
                                'Designation': designation,
                                'ImageUrl': imageUrl,
                              });
                            } catch (e) {
                              print(e);
                            }
                            Navigator.pop(context);
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
