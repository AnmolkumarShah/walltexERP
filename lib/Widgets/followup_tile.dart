import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Screens/followup_menu_screen.dart';
import 'package:walltex_app/Services/text_services.dart';

class FollowupTile extends StatelessWidget {
  dynamic data;
  FollowupTile({
    Key? key,
    this.data,
  }) : super(key: key);

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
        child: Card(
          child: ListTile(
            tileColor: Theme.of(context).primaryColor,
            leading: const Icon(
              Icons.book,
              color: Colors.white,
              size: 40,
            ),
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
                    TextHelper.textStyle(data['mobile'], "Mobile"),
                    TextHelper.textStyle(data['SalesMan'], "Salesman"),
                  ],
                ),
                TextHelper.textStyle(
                    dateFormatFromDataBase(data['nextdate']), "Followup on"),
                TextHelper.textStyle(data['nextrem'], "Remark"),
              ],
            ),
          ),
          color: Colors.green,
        ),
      ),
    );
  }
}
