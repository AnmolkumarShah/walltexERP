import 'package:flutter/material.dart';

class TextHelper {
  static textStyle(String text, String label) {
    return Text(
      "$label : $text",
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }
}
