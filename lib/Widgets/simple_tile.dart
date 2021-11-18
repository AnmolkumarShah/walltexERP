import 'package:flutter/material.dart';

class SimpleTile extends StatelessWidget {
  String? label;
  Function? fun;
  SimpleTile({
    Key? key,
    this.label,
    this.fun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => fun!(),
      child: Card(
        child: ListTile(
          title: Text(label!),
        ),
        elevation: 8,
      ),
    );
  }
}
