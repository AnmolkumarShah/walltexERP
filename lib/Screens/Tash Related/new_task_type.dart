import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/date_selected_helper.dart';
import 'package:walltex_app/Helpers/drop_down_helper.dart';
import 'package:walltex_app/Helpers/format_date.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/switch_helper.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Services/task_class.dart';
import 'package:walltex_app/Services/task_type.dart';
import 'package:walltex_app/Services/user_class.dart';

import '../../Services/loader_services.dart';

class NewTaskType extends StatefulWidget {
  int? leadId;
  Map<String, dynamic>? prev;
  NewTaskType({Key? key, this.leadId, this.prev}) : super(key: key);

  @override
  State<NewTaskType> createState() => _NewTaskTypeState();
}

class _NewTaskTypeState extends State<NewTaskType> {
  static int count = 0;
  List<User>? _users;
  List<TaskType>? _tasktypeList;

  User? _selectedUser;
  TaskType? _selectedTaskType;
  final MyDate _taskCompletedBy = MyDate(label: "Complete By");
  final MyDate _allotedDate = MyDate(label: "Alloted Date");
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

    setState(() {
      _selectedUser = _sUser;
      _selectedTaskType = _sTaskType;
      _sequenceNumber = seqNo;
      _started = MySwitch(tv: "Started", fv: "Not Started", val: starVal);
      _compleated =
          MySwitch(tv: "Completed", fv: "Not Completed", val: compVal);
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
      allotdt: formateDate(_allotedDate.value()),
      allotto: _selectedUser!.getId(),
      completed: _compleated!.getIntVal(),
      complon: formateDate(DateTime(1900)),
      leadid: widget.leadId,
      seqno: _sequenceNumber,
      started: _started!.getIntVal(),
      remark: _remark.value(),
      complby: formateDate(_taskCompletedBy.value()),
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
      allotdt: formateDate(_allotedDate.value()),
      allotto: _selectedUser!.getId(),
      completed: _compleated!.getIntVal(),
      complon: formateDate(DateTime(1900)),
      leadid: widget.leadId,
      seqno: _sequenceNumber,
      started: _started!.getIntVal(),
      remark: _remark.value(),
      complby: formateDate(_taskCompletedBy.value()),
    );

    bool result = await temp.update();
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
                    "Task Number #$_sequenceNumber",
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
                ).build(),
                Dropdown<TaskType>(
                  selected: _selectedTaskType,
                  items: _tasktypeList,
                  fun: (val) {
                    setState(() {
                      _selectedTaskType = val;
                    });
                  },
                  label: "Task Type",
                ).build(),
                _allotedDate.builder(),
                _taskCompletedBy.builder(),
                _remark.builder(),
                _started!.builder(),
                _compleated!.builder(),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
