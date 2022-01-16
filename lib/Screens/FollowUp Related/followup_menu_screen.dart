import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/phone_call.dart';
import 'package:walltex_app/Helpers/whatsApp.dart';
import 'package:walltex_app/Screens/FollowUp%20Related/all_followup_screen.dart';
import 'package:walltex_app/Screens/Lead%20Entry/lead_entry_screen.dart';
import 'package:walltex_app/Screens/FollowUp%20Related/visit_details_screen.dart';
import 'package:walltex_app/Screens/Tash%20Related/all_task_screen.dart';
import 'package:walltex_app/Screens/Tash%20Related/new_task_type.dart';
import 'package:walltex_app/Services/text_services.dart';
import 'package:walltex_app/Widgets/simple_tile.dart';

class FollowupMenuScreen extends StatelessWidget {
  dynamic data;
  FollowupMenuScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Followup Menu"),
      ),
      body: Column(
        children: [
          Hero(
            tag: data['id'],
            child: Container(
              height: 120,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
          Expanded(
            child: Column(
              children: [
                SimpleTile(
                  label: "Enter Visit Details",
                  fun: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitDetailScreen(
                          data: data,
                        ),
                      ),
                    );
                  },
                ),
                SimpleTile(
                  label: "Show Lead Details",
                  fun: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeadEntryScreen(
                          madeLead: data['leadid'],
                        ),
                      ),
                    );
                  },
                ),
                SimpleTile(
                  label: "Show Past Followup",
                  fun: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllFollowUpScreen(
                          id: data['leadid'],
                        ),
                      ),
                    );
                  },
                ),
                SimpleTile(
                  label: "Show Task",
                  fun: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllTaskScreen(
                          leadId: data['leadid'],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WhatsAppContact(number: data['mobile']),
                PhoneCall(number: data['mobile'])
              ],
            ),
          ),
        ],
      ),
    );
  }
}
