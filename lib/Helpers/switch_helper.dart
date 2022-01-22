import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/field_cover.dart';

class SwitchHelper extends StatefulWidget {
  String? trueLabel;
  String? falseLabel;
  bool? preval;
  Function? fun;
  bool? value;

  bool? enable;
  SwitchHelper({
    Key? key,
    this.falseLabel,
    this.trueLabel,
    this.preval,
    this.fun,
    this.value,
    this.enable,
  }) : super(key: key);
  @override
  State<SwitchHelper> createState() => _SwitchHelperState();
}

class _SwitchHelperState extends State<SwitchHelper> {
  @override
  Widget build(BuildContext context) {
    // print(widget.enable);
    return fieldcover(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.value == true ? widget.trueLabel! : widget.falseLabel!),
          Switch(
            value: widget.value!,
            onChanged: widget.enable == true
                ? (val) {
                    widget.fun!(val);
                    setState(() {
                      widget.value = val;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class MySwitch {
  bool? _value = false;
  String? trueLabel;
  String? falseLabel;
  bool? enable;

  MySwitch({bool? val, String? tv, String? fv, bool? en = true}) {
    _value = val;
    trueLabel = tv;
    falseLabel = fv;
    enable = en;
  }

  bool getValue() {
    return _value!;
  }

  int getIntVal() {
    if (_value == true) {
      return 1;
    } else {
      return 0;
    }
  }

  changeValue(bool? v) {
    _value = v;
  }

  disable() {
    enable = false;
  }

  Widget builder() {
    return SwitchHelper(
      falseLabel: falseLabel,
      trueLabel: trueLabel,
      preval: _value,
      fun: changeValue,
      value: _value,
      enable: enable,
    );
  }
}
