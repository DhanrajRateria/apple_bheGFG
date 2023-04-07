import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  ImageButton({
    required this.desc,
    required this.title,
    required this.imageloc,
  });

  final String title;
  final String desc;
  final String imageloc;

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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Image.network(imageloc)),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(desc)
            ]),
      ),
    );
  }
}
