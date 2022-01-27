import 'package:flutter/material.dart';

class TextHelper {
  static textStyle(String text, String label) {
    return Wrap(
      children: [
        Text(label + " : "),
        const SizedBox(width: 10),
        Text(
          text,
          textAlign: TextAlign.justify,
          overflow: TextOverflow.visible,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
