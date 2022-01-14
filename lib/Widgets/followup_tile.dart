import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Screens/FollowUp%20Related/followup_menu_screen.dart';
import 'package:walltex_app/Services/text_services.dart';
import 'package:walltex_app/control.dart';

class FollowupTile extends StatelessWidget {
  dynamic data;
  FollowupTile({
    Key? key,
    this.data,
  }) : super(key: key);
  ColorLizer colorlizer = ColorLizer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FollowupMenuScreen(
              data: data,
            ),
          ),
        );
      },
      child: Hero(
        tag: data['id'],
        child: Control.myEnvolop(
          colorlizer.getSpecialFiledColor([
            Colors.blue[200],
            Colors.amber[300],
            Colors.red[300],
            Colors.green[400],
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextHelper.textStyle(data['Name'], "Name"),
                  TextHelper.textStyle(data['place'], "Place"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextHelper.textStyle(data['mobile'], "Mobile"),
                  TextHelper.textStyle(data['SalesMan'], "Assigned To"),
                ],
              ),
              TextHelper.textStyle(
                  dateFormatFromDataBase(data['nextdate']), "Followup on"),
              TextHelper.textStyle(data['nextrem'], "Remark"),
            ],
          ),
        ),
      ),
    );
  }
}
