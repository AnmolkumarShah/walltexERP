import 'package:flutter/material.dart';
import 'package:walltex_app/Services/loader_services.dart';

// ignore: must_be_immutable
class TextCheck extends StatefulWidget {
  String? label;
  bool? value;
  Function? cbkfun;
  TextCheck({Key? key, this.label, this.value, this.cbkfun}) : super(key: key);

  @override
  _TextCheckState createState() => _TextCheckState();
}

class _TextCheckState extends State<TextCheck> {
  bool? loading;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label!,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        loading == true
            ? Loader.circular
            : Checkbox(
                shape: CircleBorder(),
                value: widget.value,
                onChanged: (value) async {
                  setState(() {
                    loading = true;
                  });

                  await widget.cbkfun!(value);

                  setState(() {
                    loading = false;
                  });
                },
              )
      ],
    );
  }
}
