import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/field_cover.dart';
import 'package:walltex_app/Services/Model_Interface.dart';

class Dropdown {
  Model? selected;
  List<Model>? items;
  Function? fun;
  String? label;

  Dropdown({this.items, this.fun, this.selected, this.label});

  List<DropdownMenuItem<Model>> buildItems(List<Model>? li) {
    List<DropdownMenuItem<Model>>? list = li!
        .map((e) => DropdownMenuItem<Model>(
              child: Text(
                e.display(),
              ),
              value: e,
            ))
        .toList();
    return list;
  }

  Widget build() {
    return fieldcover(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label!,
            style: const TextStyle(
                // fontSize: 18,
                // fontWeight: FontWeight.w600,
                ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<Model>(
              items: buildItems(items),
              onChanged: (value) {
                selected = value;
                fun!(value);
              },
              value: selected,
            ),
          ),
        ],
      ),
    );
  }
}
