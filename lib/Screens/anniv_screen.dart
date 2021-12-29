import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/control.dart';

class AnnivScreen extends StatelessWidget {
  const AnnivScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Control.annivScreen['name'].toString()),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Upcoming Anniversary...",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          Expanded(
            flex: 2,
            child: FutureBuilder(
              future: Query.execute(
                  query: "select Name,anniv,Mobile from leads order by anniv"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loader.circular;
                }
                dynamic data = snapshot.data;
                List<dynamic> actData = [];
                DateTime currdate =
                    DateTime.now().subtract(const Duration(days: 1));
                for (var element in data) {
                  if (onlyDateFromDataBase(element['anniv']).month ==
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
                        Text(dateFormatFromDataBase(actData[index]['anniv'])),
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
            "All Anniversary...",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          Expanded(
            flex: 3,
            child: FutureBuilder(
              future: Query.execute(
                  query: "select Name,anniv from leads order by anniv desc"),
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
                    trailing:
                        Text(dateFormatFromDataBase(data[index]['anniv'])),
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
