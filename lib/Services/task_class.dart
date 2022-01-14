import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/Model_Interface.dart';

class TaskType implements Model {
  int? _id;
  String? _tasktype;
  int? days;

  TaskType({int? id, String? type, int? d}) {
    _id = id;
    days = d;
    _tasktype = type;
  }

  @override
  show() {
    return _tasktype;
  }

  @override
  format(List li) {
    return li
        .map((e) => TaskType(
            type: e['task'].toString(),
            d: e['days'] == null ? 0 : e['days'],
            id: e['tasktype']))
        .toList();
  }

  @override
  getQuery() {
    return Query.allTaskType;
  }

  @override
  isEmpty() {
    return _id == -1 ? true : false;
  }

  @override
  value() {
    return _id;
  }

  save() async {
    try {
      dynamic res = await Query.execute(p1: '1', query: """
    insert into tasktype(task,days)
    values('$_tasktype',$days)
    """);
      if (res['status'] == 'success') {
        return true;
      } else {
        throw "Error";
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  int getId() {
    return _id!;
  }
}
