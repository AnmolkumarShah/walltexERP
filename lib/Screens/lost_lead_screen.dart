import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Widgets/lead_tile.dart';
import 'package:walltex_app/control.dart';

class LostLead extends StatefulWidget {
  const LostLead({Key? key}) : super(key: key);

  @override
  State<LostLead> createState() => _LostLeadState();
}

class _LostLeadState extends State<LostLead> {
  refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Control.lostLeadScreen['name'].toString()),
      ),
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: FutureBuilder(
          future: Query.execute(query: """
                  select * from leads where orderlost = 1
                  """),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader.circular;
            }
            if (snapshot.hasError) {
              return const Center(
                child: Chip(label: Text("Error Occured")),
              );
            }
            dynamic data = snapshot.data;
            if (data.length == 0) {
              return const Center(
                child: Chip(label: Text("No Leads")),
              );
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => LeadTile(
                data: data[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
