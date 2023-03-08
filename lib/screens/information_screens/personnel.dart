import 'package:flutter/material.dart';
import 'package:apple_bhe/image_buttons.dart';

class Personnel extends StatefulWidget {
  static const String id = 'personnel';

  @override
  State<Personnel> createState() => _PersonnelState();
}

class _PersonnelState extends State<Personnel> {
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
    );
  }
}
