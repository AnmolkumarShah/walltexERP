import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/completed_in_time.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Screens/Task%20Related/new_task_type.dart';
import 'package:walltex_app/Services/text_services.dart';
import 'package:walltex_app/control.dart';

class TaskTypeTile extends StatelessWidget {
  dynamic data;
  Function? refresh;
  bool? enable = true;
  bool? showCompl;
  TaskTypeTile({
    Key? key,
    this.data,
    this.refresh,
    this.enable,
    this.showCompl = false,
  }) : super(key: key);
  ColorLizer colorlizer = ColorLizer();

  String status(bool started, bool completed) {
    if (started == false && completed == false) {
      return "Not Started";
    } else if (started == true && completed == false) {
      return "Pending";
    } else if (started == true && completed == true) {
      return "Completed";
    } else {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewTaskType(
              leadId: data['leadid'],
              prev: data,
              enable: enable,
            ),
          ),
        );
        refresh!();
      },
      child: Hero(
        tag: data['taskid'],
        child: Control.myEnvolop(
          colorlizer.getSpecialFiledColor([
            Colors.blue[200],
            Colors.amber[300],
            Colors.red[300],
            Colors.green[400],
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextHelper.textStyle(data['allotedto'], "Alloted To"),
                  TextHelper.textStyle(data['task'], "Task"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextHelper.textStyle(
                      data['seqno'].toString(), "Sequence No."),
                  TextHelper.textStyle(
                      status(data['started'], data['completed']), "Status"),
                ],
              ),
              TextHelper.textStyle(
                  data['rem'] == null ? "" : data['rem'], "Remark"),
              if (data['leadname'] != null)
                TextHelper.textStyle(data['leadname'], "LeadName"),
              const Divider(color: Colors.grey, thickness: 2),
              TextHelper.textStyle(
                  onlyDateFromDataBase(data['allotdt']) == DateTime(1900)
                      ? "Not Alloted"
                      : dateFormatFromDataBase(data['allotdt']),
                  "Alloted Dt."),
              if (onlyDateFromDataBase(data['complby'].toString()) !=
                  DateTime(1900))
                TextHelper.textStyle(
                    dateFormatFromDataBase(data['complby'].toString()),
                    "To Complete By"),
              if (onlyDateFromDataBase(data['complon'].toString()) !=
                  DateTime(1900))
                TextHelper.textStyle(
                    dateFormatFromDataBase(data['complon'].toString()),
                    "Completed On"),
              if (onlyDateFromDataBase(data['complon'].toString()) !=
                  DateTime(1900))
                Text(
                  completedInTime(
                      onlyDateFromDataBase(data['complon'].toString()),
                      onlyDateFromDataBase(data['allotdt'])),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
