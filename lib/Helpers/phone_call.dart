import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneCall extends StatelessWidget {
  PhoneCall({Key? key, required this.number}) : super(key: key);
  String number;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.phone_in_talk),
      label: const Text("Phone Call"),
      onPressed: () {
        launch("tel://${number}");
      },
    );
  }
}
