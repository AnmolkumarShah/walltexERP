import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/date_selected_helper.dart';
import 'package:walltex_app/Helpers/drop_down_helper.dart';
import 'package:walltex_app/Helpers/field_cover.dart';
import 'package:walltex_app/Helpers/format_date.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/switch_helper.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Helpers/whatsApp.dart';
import 'package:walltex_app/Screens/Lead%20Entry/lead_entry_screen.dart';
import 'package:walltex_app/Services/task_class.dart';
import 'package:walltex_app/Services/task_type.dart';
import 'package:walltex_app/Services/user_class.dart';

import '../../Services/loader_services.dart';

class NewTaskType extends StatefulWidget {
  int? leadId;
  Map<String, dynamic>? prev;
  bool? enable = true;
  NewTaskType({Key? key, this.leadId, this.prev, this.enable})
      : super(key: key);

  @override
  State<NewTaskType> createState() => _NewTaskTypeState();
}

class _NewTaskTypeState extends State<NewTaskType> {
  static int count = 0;
  List<User>? _users;
  List<TaskType>? _tasktypeList;

  User? _selectedUser;
  TaskType? _selectedTaskType;
  final MyDate _taskCompletedBy = MyDate(label: "Complete By", dateTime: true);
  final MyDate _allotedDate = MyDate(label: "Alloted Date", dateTime: true);
  final Input _remark = Input(label: "Remark");
  MySwitch? _started;

  MySwitch? _compleated;

  int? _sequenceNumber = -1;
  bool _loading = false;

  Future init() async {
    List<User>? userList = await User.allUsers();
    List<TaskType>? taskTypeList = await Query.fetch(TaskType());
    int seqCount = await TaskTypeModel.nextSequenceNumber(widget.leadId!);

    userList.insert(0, User(ids: -1, nm: "Select User"));
    taskTypeList!.insert(0, TaskType(id: -1, type: "Select Task Type", d: 1));

    setState(() {
      _users = userList;
      _tasktypeList = taskTypeList;
      _selectedUser = userList.first;
      _selectedTaskType = taskTypeList.first;
      _sequenceNumber = seqCount;
      _started = MySwitch(tv: "Started", fv: "Not Started", val: false);
      _compleated = MySwitch(tv: "Completed", fv: "Not Completed", val: false);
    });

    if (widget.prev != null) {
      getSet();
    }

    return;
  }

  getSet() async {
    // print(widget.prev);
    String usernm = widget.prev!['allotedto'];
    String tasknm = widget.prev!['task'];

    try {
      String complDate = widget.prev!['complby'].toString();
      String allotDate = widget.prev!['allotdt'].toString();
      if (complDate == "null" || allotDate == "null") {
        throw "Error";
      }
      _taskCompletedBy.setValue(complDate);
      _allotedDate.setValue(allotDate);
    } catch (e) {
      showSnakeBar(context, "Error In Setting Dates");
    }

    User _sUser = _users!.firstWhere((e) => e.getName() == usernm);
    TaskType _sTaskType = _tasktypeList!.firstWhere((e) => e.show() == tasknm);
    int seqNo = widget.prev!['seqno'];
    String rem = widget.prev!['rem'] == null ? "" : widget.prev!['rem'];
    _remark.setValue(rem);

    bool compVal = (widget.prev!['completed'] == null ||
            widget.prev!['completed'] == false)
        ? false
        : true;
    bool starVal =
        (widget.prev!['started'] == null || widget.prev!['started'] == false)
            ? false
            : true;

    if (widget.enable == false) {
      // _remark.disable();
      _allotedDate.disable();
      _taskCompletedBy.disable();
    }

    setState(() {
      _selectedUser = _sUser;
      _selectedTaskType = _sTaskType;
      _sequenceNumber = seqNo;
      _started = MySwitch(
        tv: "Started",
        fv: "Not Started",
        val: starVal,
        en: starVal == true ? false : widget.enable,
      );
      _compleated = MySwitch(
        tv: "Completed",
        fv: "Not Completed",
        val: compVal,
        en: compVal == true ? false : true,
      );
    });
  }

  _fetchData() async {
    if (count > 0) return;
    await init();
    count++;
  }

  @override
  initState() {
    super.initState();
    count = 0;
  }

  @override
  void didChangeDependencies() {
    _selectedUser = null;
    _selectedTaskType = null;
    super.didChangeDependencies();
  }

  void save() async {
    if (_selectedUser!.getId() == -1) {
      showSnakeBar(context, "Select A User First");
      return;
    }
    if (_selectedTaskType!.getId() == -1) {
      showSnakeBar(context, "Select A Type First");
      return;
    }

    setState(() {
      _loading = true;
    });
    TaskTypeModel temp = TaskTypeModel(
      tasktype: _selectedTaskType!.getId(),
      allotdt: formateDate(DateTime(1900)),
      allotto: _selectedUser!.getId(),
      completed: 0,
      complon: formateDate(DateTime(1900)),
      leadid: widget.leadId,
      seqno: _sequenceNumber,
      started: 0,
      remark: _remark.value(),
      complby: formateDate(DateTime(1900)),
    );

    bool result = await temp.save();
    if (result == true) {
      showSnakeBar(context, "Saved Successfully");
    } else {
      showSnakeBar(context, "Error In Saving");
    }

    setState(() {
      _loading = false;
    });
    Navigator.pop(context);
  }

  void update() async {
    if (_selectedUser!.getId() == -1) {
      showSnakeBar(context, "Select A User First");
      return;
    }
    if (_selectedTaskType!.getId() == -1) {
      showSnakeBar(context, "Select A Type First");
      return;
    }

    if (_allotedDate.isEmpty()) {
      showSnakeBar(context, "Please Select Date Of Allotment");
      return;
    }

    if (_taskCompletedBy.isEmpty()) {
      showSnakeBar(
          context, "Please Select Date When This Task Should Be Completed");
      return;
    }

    if (_started!.getValue() == false && _compleated!.getValue() == true) {
      showSnakeBar(context,
          "Task is not started and yet competed, please check this !!!");
      return;
    }
    setState(() {
      _loading = true;
    });
    TaskTypeModel temp = TaskTypeModel(
      tasktype: _selectedTaskType!.getId(),
      allotdt: formateDate(_allotedDate.value().year == DateTime(1900).year
          ? DateTime.now()
          : _allotedDate.value()),
      allotto: _selectedUser!.getId(),
      completed: _compleated!.getIntVal(),
      complon: formateDate(
        _compleated!.getValue() == true ? DateTime.now() : DateTime(1900),
      ),
      leadid: widget.leadId,
      seqno: _sequenceNumber,
      started: _started!.getIntVal(),
      remark: _remark.value(),
      complby: formateDate(_compleated!.getIntVal() == 1
          ? DateTime.now()
          : _taskCompletedBy.value()),
      taskid: widget.prev!['taskid'],
    );

    bool result = await temp.update();

    if (result == true) {
      showSnakeBar(context, "Updated Successfully");
    } else {
      showSnakeBar(context, "Error In Updating");
    }

    if (temp.completed == 1) {
      String res = await TaskTypeModel.markNextTaskStart(
          temp.leadid, temp.taskid, temp.seqno);
      String msgText =
          "Task ${widget.prev!['seqno']} of lead - ${widget.prev!['leadname']} is completed";
      await openwhatsapp(context, msgText, widget.prev!['leadnumber']);
      showSnakeBar(context, res);
    }

    if (result == true) {
      showSnakeBar(context, "Updated Successfully");
    } else {
      showSnakeBar(context, "Error In Updating");
    }

    setState(() {
      _loading = false;
    });
    Navigator.pop(context);
  }

  onlyComplete() {
    Duration duration = onlyDateFromDataBase(widget.prev!['complon'])
        .difference(_allotedDate.value());
    int hours = duration.inHours;
    int days = (hours / 24).ceil();
    int rem_hour = (hours % 24);
    return Column(
      children: [
        fieldcover(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Completed On"),
            Text(
              DateFormat.yMd('en_US')
                  .add_jms()
                  .format(onlyDateFromDataBase(widget.prev!['complon'])),
            )
          ],
        )),
        Text(
          "Time Taken $days days and $rem_hour hours",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Task")),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader.circular;
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Task Number #$_sequenceNumber ${(widget.prev == null || widget.prev!['leadname'] == null) ? "" : "of ${widget.prev!['leadname']}"}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Dropdown<User>(
                  selected: _selectedUser,
                  items: _users,
                  fun: (val) {
                    setState(() {
                      _selectedUser = val;
                    });
                  },
                  label: "Assigned To",
                  enable: widget.enable,
                ).build(),
                Dropdown<TaskType>(
                  selected: _selectedTaskType,
                  items: _tasktypeList,
                  enable: widget.enable,
                  fun: (val) {
                    setState(() {
                      _selectedTaskType = val;
                      if (widget.prev != null) {
                        int days = (val as TaskType).days!;
                        try {
                          _taskCompletedBy.setDate(
                              _allotedDate.value().add(Duration(days: days)));
                        } catch (e) {
                          _taskCompletedBy.setDate(
                              DateTime.now().add(Duration(days: days)));
                        }
                        showSnakeBar(context,
                            "Complete Date Set $days Days From Allotment Date");
                      }
                    });
                  },
                  label: "Task Type",
                ).build(),
                widget.prev != null
                    ? Column(
                        children: [
                          _allotedDate.builder(),
                          _taskCompletedBy.builder(),
                          _remark.builder(),
                          _started!.builder(),
                          _started!.getValue() == true
                              ? _compleated!.builder()
                              : const SizedBox(height: 0),
                        ],
                      )
                    : const SizedBox(height: 0),
                if (_compleated!.getValue() == true) onlyComplete(),
                _loading == true
                    ? Loader.circular
                    : widget.prev == null
                        ? ElevatedButton(
                            onPressed: save,
                            child: const Text("Save"),
                          )
                        : ElevatedButton(
                            onPressed: update,
                            child: const Text("Update"),
                          ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeadEntryScreen(
                          madeLead: widget.leadId,
                          taskShow: false,
                        ),
                      ),
                    );
                  },
                  child: const Text("Show Lead Detail"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
