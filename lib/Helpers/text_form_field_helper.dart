import 'package:flutter/material.dart';

class TextFormHelper extends StatelessWidget {
  const TextFormHelper({
    Key? key,
    this.label,
    this.obscure,
    this.controller,
  }) : super(key: key);

  final String? label;
  final TextEditingController? controller;
  final bool? obscure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure!,
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

  Widget builder() {
    return TextFormHelper(
      label: _label,
      controller: _controller,
      obscure: _obscure,
    );
  }

  String value() {
    return _controller!.value.text.trim();
  }
}
