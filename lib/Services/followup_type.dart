import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/Model_Interface.dart';

class FollowupType implements Model {
  int? _id;
  String? _desc; //ftype in db

  FollowupType({int? id, String? desc}) {
    _id = id;
    _desc = desc;
  }

  @override
  show() {
    return _desc;
  }

  @override
  format(List li) {
    return li
        .map((e) => FollowupType(desc: e['ftype'].toString(), id: e['id']))
        .toList();
  }

  @override
  getQuery() {
    return Query.allFollowupType;
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
    insert into followup_type(ftype)
    values('$_desc')
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
