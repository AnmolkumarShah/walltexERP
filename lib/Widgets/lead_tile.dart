import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Screens/lead_entry_screen.dart';
import 'package:walltex_app/Services/text_services.dart';

class LeadTile extends StatelessWidget {
  dynamic data;
  LeadTile({Key? key, this.data}) : super(key: key);
  ColorLizer colorlizer = ColorLizer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeadEntryScreen(
              madeLead: data['id'],
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          tileColor: colorlizer.getSpecialFiledColor([
            Colors.blue[200],
            Colors.amber[300],
            Colors.red[300],
            Colors.green[400],
          ]),
          // leading: const Icon(
          //   Icons.book,
          //   color: Colors.white,
          //   size: 20,
          // ),
          title: Column(
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
                  TextHelper.textStyle(data['Mobile'], "Mobile"),
                  TextHelper.textStyle(data['sman'].toString(), "Salesman"),
                ],
              ),
              TextHelper.textStyle(
                  dateFormatFromDataBase(data['nextfollowupon']),
                  "Followup on"),
              TextHelper.textStyle(data['nextfollowuprem'], "Remark"),
            ],
          ),
        ),
        color: Colors.green,
      ),
    );
  }
}
