import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/field_cover.dart';

String display(dynamic e) {
  try {
    return e.show();
  } catch (e) {
    return "Name";
  }
}

class Dropdown<T> {
  T? selected;
  List<T>? items;
  Function? fun;
  String? label;

  Dropdown({this.items, this.fun, this.selected, this.label});

  List<DropdownMenuItem<T>> buildItems(List<T>? li) {
    List<DropdownMenuItem<T>>? list = li!
        .map((e) => DropdownMenuItem<T>(
              child: Text(
                display(e!),
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
            child: DropdownButton<T>(
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
