import 'package:flutter/material.dart';
import 'package:apple_bhe/image_buttons.dart';
import 'package:image_picker/image_picker.dart';

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
      floatingActionButton: FloatingActionButton(onPressed: () {
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
                    decoration: InputDecoration(labelText: "Enter Designation"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery, // or ImageSource.camera
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
              );
            });
      }),
    );
  }
}
