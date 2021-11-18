import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Widgets/lead_tile.dart';
import 'package:walltex_app/control.dart';

class GainedLEad extends StatefulWidget {
  const GainedLEad({Key? key}) : super(key: key);

  @override
  State<GainedLEad> createState() => _GainedLEadState();
}

class _GainedLEadState extends State<GainedLEad> {
  refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Control.gainedLeadScreen['name'].toString()),
      ),
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: FutureBuilder(
          future: Query.execute(query: """
                  select * from leads where ordergain = 1
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
