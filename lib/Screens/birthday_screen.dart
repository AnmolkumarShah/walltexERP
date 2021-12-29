import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/querie.dart';
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
          const Text(
            "Upcoming Birthdays...",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          Expanded(
            flex: 2,
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
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.cake),
                    title: Text(actData[index]['Name']),
                    subtitle:
                        Text(dateFormatFromDataBase(actData[index]['dob'])),
                    trailing: IconButton(
                      icon: const Icon(Icons.phone_in_talk),
                      onPressed: () {
                        launch("tel://${actData[index]['Mobile']}");
                      },
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
          const Text(
            "All Birthdays...",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
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
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.cake),
                    title: Text(data[index]['Name']),
                    trailing: Text(dateFormatFromDataBase(data[index]['dob'])),
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
