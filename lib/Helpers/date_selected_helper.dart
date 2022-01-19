import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/field_cover.dart';

// ignore: must_be_immutable
class DateHelper extends StatefulWidget {
  Function? fun;
  String? label;
  DateTime? givenDate;
  bool? enable = true;
  DateHelper({Key? key, this.fun, this.label, this.givenDate, this.enable})
      : super(key: key);

  @override
  State<DateHelper> createState() => _DateHelperState();
}

class _DateHelperState extends State<DateHelper> {
  DateTime? _selectedDate;

  DateTime value() {
    return _selectedDate!;
  }

  @override
  void initState() {
    super.initState();
    if (widget.givenDate != null) {
      _selectedDate = widget.givenDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return fieldcover(
      child: _selectedDate != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.label!),
                Text(DateFormat.yMMMMEEEEd().format(_selectedDate!)),
                widget.enable == true
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = null;
                          });
                          widget.fun!(null);
                        },
                        icon: const Icon(Icons.cancel),
                      )
                    : const SizedBox(width: 0),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.label!),
                IconButton(
                  onPressed: () async {
                    final DateTime? val = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2050),
                    );
                    setState(() {
                      _selectedDate = val;
                    });
                    widget.fun!(val);
                  },
                  icon: const Icon(Icons.calendar_today_outlined),
                ),
              ],
            ),
    );
  }
}

class MyDate {
  DateTime? _value;
  String? label;
  bool? enable;

  MyDate({this.label = 'Select Date', this.enable = true});

  changeDate(DateTime? d) {
    _value = d;
  }

  DateTime value() {
    return _value!;
  }

  setValue(String val) {
    DateTime date = onlyDateFromDataBase(val);
    _value = date;
  }

  setDate(DateTime date) {
    _value = date;
  }

  bool isEmpty() {
    return _value == null ? true : false;
  }

  void disable() {
    enable = false;
  }

  Widget builder() {
    return DateHelper(
      fun: changeDate,
      label: label,
      givenDate: _value,
      enable: enable,
    );
  }
}
