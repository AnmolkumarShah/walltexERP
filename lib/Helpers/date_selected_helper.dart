import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walltex_app/Helpers/field_cover.dart';

// ignore: must_be_immutable
class DateHelper extends StatefulWidget {
  Function? fun;
  String? label;
  DateTime? givenDate;
  DateHelper({Key? key, this.fun, this.label, this.givenDate})
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
                Text(DateFormat.yMMMMEEEEd().format(_selectedDate!)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                    });
                    widget.fun!(null);
                  },
                  icon: const Icon(Icons.cancel),
                ),
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

  MyDate({this.label = 'Select Date'});

  changeDate(DateTime? d) {
    _value = d;
  }

  value() {
    return _value;
  }

  bool isEmpty() {
    return _value == null ? true : false;
  }

  Widget builder() {
    return DateHelper(
      fun: changeDate,
      label: label,
      givenDate: _value,
    );
  }
}
