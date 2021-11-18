import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/text_services.dart';

class AllFollowUpScreen extends StatefulWidget {
  int? id;
  AllFollowUpScreen({Key? key, this.id}) : super(key: key);

  @override
  _AllFollowUpScreenState createState() => _AllFollowUpScreenState();
}

class _AllFollowUpScreenState extends State<AllFollowUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Followup"),
      ),
      body: FutureBuilder(
        future: Query.execute(
            query:
                "select * from followup where leadid = ${widget.id} order by id desc"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader.circular;
          }
          dynamic data = snapshot.data;
          print(data);
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => Card(
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
                    TextHelper.textStyle(
                        dateFormatFromDataBase(data[index]['followupdt']),
                        "Visited on"),
                    TextHelper.textStyle(data[index]['nextrem'], "Remark"),
                    TextHelper.textStyle(
                        dateFormatFromDataBase(data[index]['nextdate']),
                        "Followup on"),
                    TextHelper.textStyle(
                        data[index]['isdone'].toString(), "is done"),
                  ],
                ),
              ),
              color: Colors.green,
            ),
          );
        },
      ),
    );
  }
}
