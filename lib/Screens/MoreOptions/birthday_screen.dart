import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/phone_call.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/whatsApp.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/control.dart';

class BirthdayScreen extends StatelessWidget {
  const BirthdayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Control.birthdayScreen['name'].toString()),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Chip(
            label: Text("Birthday This Month", style: Control.eventStyle),
          ),
          Expanded(
            flex: 1,
            child: FutureBuilder(
              future: Query.execute(
                  query: "select Name,dob,Mobile from leads order by dob asc"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loader.circular;
                }
                dynamic data = snapshot.data;
                List<dynamic> actData = [];
                DateTime currdate =
                    DateTime.now().subtract(const Duration(days: 1));
                for (var element in data) {
                  if (onlyDateFromDataBase(element['dob']).month ==
                      currdate.month) {
                    actData.add(element);
                  }
                }
                return ListView.builder(
                  itemCount: actData.length,
                  itemBuilder: (context, index) => Control.myEnvolop(
                    Colors.pink[100],
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          actData[index]['Name'],
                          style: Control.eventStyle,
                        ),
                        Text(
                          dateFormatFromDataBase(actData[index]['dob']),
                          style: Control.eventStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WhatsAppContact(number: actData[index]['Mobile']),
                            PhoneCall(number: actData[index]['Mobile']),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          const SizedBox(
            height: 20,
          ),
          Chip(
            label: Text("All Birthday Data", style: Control.eventStyle),
          ),
          Expanded(
            flex: 3,
            child: FutureBuilder(
              future: Query.execute(
                  query: "select Name,dob from leads order by dob desc"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loader.circular;
                }
                dynamic data = snapshot.data;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(2),
                    child: ListTile(
                      dense: true,
                      tileColor: Colors.pink[100],
                      leading: const Icon(Icons.cake),
                      title: Text(data[index]['Name']),
                      trailing:
                          Text(dateFormatFromDataBase(data[index]['dob'])),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
