import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/field_cover.dart';

class TextFormHelper extends StatelessWidget {
  const TextFormHelper({
    Key? key,
    this.label,
    this.obscure,
    this.controller,
    this.type,
  }) : super(key: key);

  final String? label;
  final TextEditingController? controller;
  final bool? obscure;
  final TextInputType? type;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure!,
      keyboardType: type,
      decoration: InputDecoration(
        label: Text(label!),
      ),
    );
  }
}

class Input {
  TextEditingController? _controller;
  String? _label;
  TextInputType? _inputType;
  bool? _obscure;

  Input({String? label = "Placeholder"}) {
    _controller = TextEditingController(text: "");
    _label = label;
    _inputType = TextInputType.name;
    _obscure = false;
  }

  Input.password({String? label = "Placeholder"}) {
    _controller = TextEditingController(text: "");
    _label = label;
    _inputType = TextInputType.visiblePassword;
    _obscure = true;
  }

  Input.number({String? label = "Placeholder"}) {
    _controller = TextEditingController(text: "");
    _label = label;
    _inputType = TextInputType.number;
    _obscure = false;
  }

  Input.multiline({String? label = "Placeholder"}) {
    _controller = TextEditingController(text: "");
    _label = label;
    _inputType = TextInputType.multiline;
    _obscure = false;
  }

  Input.email({String? label = "Placeholder"}) {
    _controller = TextEditingController(text: "");
    _label = label;
    _inputType = TextInputType.emailAddress;
    _obscure = false;
  }

  Widget builder() {
    return fieldcover(
      child: TextFormHelper(
        label: _label,
        controller: _controller,
        obscure: _obscure,
        type: _inputType,
      ),
    );
  }

  String value() {
    return _controller!.value.text.trim();
  }

  int valueInt() {
    try {
      return int.parse(value());
    } catch (e) {
      return -1;
    }
  }

  void setValue(String val) {
    _controller = TextEditingController(text: val);
  }

  bool isEmpty() {
    return value().isEmpty ? true : false;
  }
}
