import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OptionTile extends StatelessWidget {
  String? title;
  Widget? next;
  OptionTile({
    Key? key,
    this.title,
    this.next,
  }) : super(key: key);

  ColorLizer colorlizer = ColorLizer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => next!,
          ),
        );
      },
      child: Card(
        color: colorlizer.getSpecialFiledColor([
          Colors.blue[200],
          Colors.amber[300],
          Colors.red[300],
          Colors.green[400],
        ]),
        child: ListTile(
          title: Text(
            title!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        elevation: 8,
        shadowColor: Colors.green,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.green, width: 1)),
      ),
    );
  }
}
