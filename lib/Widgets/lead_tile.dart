import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Screens/FollowUp%20Related/followup_menu_screen.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/text_services.dart';

class LeadTile extends StatefulWidget {
  dynamic data;
  LeadTile({Key? key, this.data}) : super(key: key);

  @override
  State<LeadTile> createState() => _LeadTileState();
}

class _LeadTileState extends State<LeadTile> {
  ColorLizer colorlizer = ColorLizer();

  Color? _tileColor;

  @override
  Widget build(BuildContext context) {
    if (widget.data['ordergain'] == false &&
        widget.data['orderlost'] == false) {
      setState(() {
        _tileColor = Colors.greenAccent[200];
      });
    }

    if (widget.data['ordergain'] == true) {
      setState(() {
        _tileColor = Colors.green;
      });
    }

    if (widget.data['orderlost'] == true) {
      setState(() {
        _tileColor = Colors.red;
      });
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FollowupMenuScreen(
              all: false,
              data: {
                'leadid': widget.data['id'],
                'mobile': widget.data['Mobile']
              },
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          tileColor: _tileColor,
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
                  TextHelper.textStyle(widget.data['Name'], "Name"),
                  TextHelper.textStyle(widget.data['place'], "Place"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextHelper.textStyle(widget.data['Mobile'], "Mobile"),
                  FutureBuilder(
                    future: Query.execute(
                        query:
                            "select usr_nm from usr_mast where id = ${widget.data['sman']}"),
                    builder: (context, snapshot) {
                      List<dynamic> data;
                      try {
                        data = snapshot.data as List<dynamic>;
                      } catch (e) {
                        data = [
                          {'usr_nm': "Loading"}
                        ];
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Loader.circular;
                      }
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      return TextHelper.textStyle(
                          data[0]['usr_nm'], "Assigned To");
                    },
                  ),
                ],
              ),
              widget.data['nextfollowupon'] == null
                  ? const SizedBox(height: 0)
                  : TextHelper.textStyle(
                      dateFormatFromDataBase(widget.data['nextfollowupon']),
                      "Followup on"),
              TextHelper.textStyle(widget.data['nextfollowuprem'], "Remark"),
            ],
          ),
        ),
        color: Colors.green,
      ),
    );
  }
}
