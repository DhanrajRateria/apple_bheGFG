import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  ImageButton({
    required this.desc,
    required this.title,
    required this.imagename,
  });

  final String title;
  final String desc;
  final String imagename;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: SizedBox(
        height: 500,
        width: 500,
        child: Column(children: [
          Image.asset("images/personnel/$imagename.jpg"),
          Text(title),
          Text(desc)
        ]),
      ),
    );
  }
}
