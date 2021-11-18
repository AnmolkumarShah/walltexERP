import 'package:flutter/material.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:provider/provider.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/date_selected_helper.dart';
import 'package:walltex_app/Helpers/format_date.dart';
import 'package:walltex_app/Helpers/get_geo_location.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/switch_helper.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Providers/control_provider.dart';
import 'package:walltex_app/Services/loader_services.dart';

class VisitDetailScreen extends StatefulWidget {
  dynamic data;
  VisitDetailScreen({Key? key, this.data}) : super(key: key);

  @override
  State<VisitDetailScreen> createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends State<VisitDetailScreen> {
  final Input _remark = Input.multiline(label: "Remark");
  final Input _details = Input(label: "Details");

  final MyDate _nextFollowup = MyDate(label: "Next Followup Date");

  final MySwitch gained = MySwitch(
    tv: "Order gained",
    fv: "Order Not Gained",
    val: false,
  );

  bool loading = false;

  final MySwitch closed = MySwitch(
    tv: "Order Closed",
    fv: "Order Not Closed",
    val: false,
  );

  bool check() {
    if (_remark.isEmpty()) {
      return false;
    } else {
      return true;
    }
  }

  bool followupChange() {
    if (_nextFollowup.isEmpty() ||
        _nextFollowup.value().isBefore(DateTime.now())) {
      return false;
    } else {
      return true;
    }
  }

  majorChange() async {
    try {
      Position pos = await determinePosition();
      double? lat = pos.latitude;
      double? lon = pos.longitude;
      String? presentDate = formateDate(DateTime.now());
      int? currId = Provider.of<ControlProvider>(context, listen: false)
          .getUser()
          .getId();

      await followUpEntry(isDone: 1);
      final followupres = await Query.execute(
        p1: '1',
        query: """

        update leads
        set lat = $lat, long = $lon,ordergain = ${gained.getIntVal()}, orderlost = ${closed.getIntVal()},
        nextfollowupon = '$presentDate',gaindetails = '${_details.value()}', 
        lostdetails = '${_details.value()}'
        where id = ${widget.data['leadid']}
        """,
      );

      final endRes = await Query.execute(
        p1: '1',
        query: """

        update followup
        set isdone = 1,isdoneid = $currId
        where leadid = ${widget.data['leadid']}
        """,
      );

      if (followupres['status'] == 'success' && endRes['status'] == 'success') {
        showSnakeBar(context, "New Followup Added Successfully");
      } else {
        throw "Error in Saving New Followup";
      }
    } catch (e) {
      print(e);
    }
  }

  followUpEntry({int? isDone = 0}) async {
    setState(() {
      loading = true;
    });
    try {
      String? presentDate = formateDate(DateTime.now());
      String? followupDate = formateDate(_nextFollowup.value());
      Position pos = await determinePosition();
      double? lat = pos.latitude;
      double? lon = pos.longitude;
      String? remark = _remark.value();
      int? currId = Provider.of<ControlProvider>(context, listen: false)
          .getUser()
          .getId();

      final doneRecent = await Query.execute(
        p1: '1',
        query: """

        update followup
        set isdone = 1,isdoneid = $currId
        where leadid = ${widget.data['leadid']}

        """,
      );

      final followupres = await Query.execute(
        p1: '1',
        query: """

        insert into followup(followupdt,leadid,sman,nextrem,nextdate,
        isdone,isdoneid,lat,long,leadremarks)
        values('$presentDate',${widget.data['leadid']},$currId,'$remark','$followupDate',
        $isDone,$currId,$lat,$lon,'${widget.data['remarks']}')

        """,
      );

      final leadres = await Query.execute(
        p1: '1',
        query: """

        update leads
        set lat = $lat, long = $lon,ordergain = ${gained.getIntVal()}, orderlost = ${closed.getIntVal()},
        nextfollowupon = '$presentDate',nextfollowuprem = '$remark'
        where id = ${widget.data['leadid']}
        """,
      );

      if (followupres['status'] == 'success' &&
          doneRecent['status'] == 'success' &&
          leadres['status'] == 'success') {
        showSnakeBar(context, "New Followup Added Successfully");
      } else {
        throw "Error in Saving New Followup";
      }
    } catch (e) {
      print(e);
      showSnakeBar(context, e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    handleSave() async {
      if (check()) {
        if (gained.getValue() == true || closed.getValue() == true) {
          // final update into lead
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Enter Details"),
              content: _details.builder(),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Save"))
              ],
            ),
          );
          await majorChange();
        } else {
          // Enter into follow up
          if (followupChange()) {
            await followUpEntry();
          } else {
            showSnakeBar(
                context, "Enter All Fields & And Date Should Be Today After");
          }
        }
        Navigator.pop(context);
      } else {
        showSnakeBar(
            context, "Enter All Fields & And Date Should Be Today After");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Visit Detail"),
      ),
      body: Center(
        child: Column(
          children: [
            Chip(
                label: Text(
                    "Last Date : ${dateFormatFromDataBase(widget.data['nextdate'])} ")),
            _remark.builder(),
            _nextFollowup.builder(),
            gained.builder(),
            closed.builder(),
            loading == true
                ? Loader.circular
                : ElevatedButton(
                    onPressed: handleSave,
                    child: const Text("Save"),
                  )
          ],
        ),
      ),
    );
  }
}
