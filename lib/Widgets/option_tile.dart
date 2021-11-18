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
        color: Theme.of(context).primaryColor,
        child: ListTile(
          title: Text(
            title!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Colors.white,
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
