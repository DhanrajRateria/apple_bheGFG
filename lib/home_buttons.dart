import 'package:apple_bhe/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  HomeButton({
    required this.onPressed,
    required this.title,
    required this.imagename,
  });

  final String title;
  final Function() onPressed;
  late String nextPage;
  final String imagename;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/buttons/$imagename.png",
                  height: 80.0,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
          ),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Color(0xffFFFFFF),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5)),
              boxShadow: [
                BoxShadow(),
              ]),
        ),
        onPressed: onPressed
      ),
    );
  }
}