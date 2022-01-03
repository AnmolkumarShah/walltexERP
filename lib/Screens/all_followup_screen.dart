import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/text_services.dart';
import 'package:walltex_app/control.dart';

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
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => Control.myEnvolop(
              Colors.orange,
              Column(
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
                  TypeLabel(
                    id: data[index]['followup_type'],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TypeLabel extends StatelessWidget {
  TypeLabel({Key? key, this.id}) : super(key: key);
  dynamic id;

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return Text("Type Not Set", style: Control.onlybold);
    }
    return FutureBuilder(
      future: Query.execute(
          query: "select ftype from followup_type where id = $id"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Error in getting Followup Type");
        }
        List<dynamic> data = snapshot.data as List<dynamic>;
        return TextHelper.textStyle(data[0]['ftype'], "Type");
      },
    );
  }
}
