import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/date_selected_helper.dart';
import 'package:walltex_app/Helpers/drop_down_helper.dart';
import 'package:walltex_app/Helpers/format_date.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/switch_helper.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Services/task_class.dart';

import 'loader_services.dart';
import 'user_class.dart';

class TaskTypeModel {
  int? taskid;
  int? tasktype; // id of tasktype from task table
  int? leadid; // id of corres. lead
  int? seqno; // sequence of each task type of a perti lead
  int? allotto; // id of user
  String? allotdt; // date of allotement of tasktype
  int? started; // is tasktype started -> bit bool
  String? complby; // date task type should be compleated
  int? completed; // is tasktype compleated -> bit bool
  String? complon; // date of task type completed
  String? remark;

  TaskTypeModel({
    this.allotdt,
    this.allotto,
    this.complby,
    this.completed,
    this.complon,
    this.leadid,
    this.seqno,
    this.started,
    this.taskid,
    this.tasktype,
    this.remark,
  });

  static Future<int> nextSequenceNumber(int id) async {
    List<dynamic> result = await Query.execute(query: """
    select count(*) from tasks where leadid = $id
    """);
    return result[0]['Column1'] + 1;
  }

  save() async {
    try {
      dynamic result = await Query.execute(p1: '1', query: """
      insert into tasks(tasktype,leadid,seqno,allotto,allotdt,started,complby,completed,complon,rem)
      values(${tasktype},${leadid},${seqno},${allotto},'${allotdt}',${started},
      '${complby}',${completed},'${complon}','${remark}')
      """);
      print(result);
      if (result['status'] == "success") {
        return true;
      } else {
        throw "Error";
      }
    } catch (e) {
      return false;
    }
  }

  update() async {
    try {
      dynamic result = await Query.execute(p1: '1', query: """
        update tasks set
        tasktype = ${tasktype},leadid = ${leadid},seqno = ${seqno},allotto = ${allotto},
        allotdt = '${allotdt}',started = ${started},complby = '${complby}',
        completed = ${completed},complon = '${complon}', rem = '${remark}'
        where leadid = ${leadid} and seqno = ${seqno}
        """);
      print(result);
      if (result['status'] == "success") {
        return true;
      } else {
        throw "Error";
      }
    } catch (e) {
      return false;
    }
  }
}

class TaskTypeItem extends StatefulWidget {
  int? leadId;
  Map<String, dynamic>? prev;
  TaskTypeItem({Key? key, this.leadId, this.prev}) : super(key: key);

  @override
  State<TaskTypeItem> createState() => _TaskTypeItemState();
}

class _TaskTypeItemState extends State<TaskTypeItem> {
  static int count = 0;
  List<User>? _users;
  List<TaskType>? _tasktypeList;

  User? _selectedUser;
  TaskType? _selectedTaskType;
  final MyDate _taskCompletedBy = MyDate(label: "Complete By");
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
    int userId = widget.prev!['allotto'];
    int taskId = widget.prev!['tasktype'];
    String complDate = widget.prev!['complby'];
    User _sUser = _users!.firstWhere((e) => e.getId() == userId);
    TaskType _sTaskType = _tasktypeList!.firstWhere((e) => e.getId() == taskId);
    _taskCompletedBy.setValue(complDate);
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

    print("------------------");
    print(starVal);

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
    if (_taskCompletedBy.isEmpty()) {
      showSnakeBar(context, "Select CompleteBy Date");
      return;
    }
    setState(() {
      _loading = true;
    });
    TaskTypeModel temp = TaskTypeModel(
      tasktype: _selectedTaskType!.getId(),
      allotdt: formateDate(DateTime.now()),
      allotto: _selectedUser!.getId(),
      complby: formateDate(_taskCompletedBy.value()),
      completed: _compleated!.getIntVal(),
      complon: formateDate(DateTime(1900)),
      leadid: widget.leadId,
      seqno: _sequenceNumber,
      started: _started!.getIntVal(),
      taskid: 0, // just to enter
      remark: _remark.value(),
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
    if (_taskCompletedBy.isEmpty()) {
      showSnakeBar(context, "Select CompleteBy Date");
      return;
    }
    setState(() {
      _loading = true;
    });
    TaskTypeModel temp = TaskTypeModel(
      tasktype: _selectedTaskType!.getId(),
      allotdt: formateDate(DateTime.now()),
      allotto: _selectedUser!.getId(),
      complby: formateDate(_taskCompletedBy.value()),
      completed: _compleated!.getIntVal(),
      complon: formateDate(DateTime(1900)),
      leadid: widget.leadId,
      seqno: _sequenceNumber,
      started: _started!.getIntVal(),
      taskid: 0, // just to enter
      remark: _remark.value(),
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader.circular;
        }
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              border: Border.all(
            width: 2,
          )),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Number $_sequenceNumber"),
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
    );
  }
}
