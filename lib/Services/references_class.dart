import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/Model_Interface.dart';

class References implements Model {
  int? _id;
  String? _desc;

  References({int? id, String? desc}) {
    _id = id;
    _desc = desc;
  }

  @override
  display() {
    return _desc;
  }

  @override
  format(List li) {
    return li
        .map((e) => References(desc: e['Refferance'].toString(), id: e['id']))
        .toList();
  }

  @override
  getQuery() {
    return Query.allReferences;
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
    insert into refferance(Refferance)
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
}
