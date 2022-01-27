import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/admin_class.dart';
import 'package:walltex_app/Services/salesman_class.dart';

class User {
  // ignore: unused_field
  int? _id;
  // ignore: unused_field
  String? _name;
  // ignore: unused_field
  String? _password;
  // ignore: unused_field
  bool? _isAdmin;
  // ignore: unused_field
  bool? _isBlock;
  // ignore: unused_field
  String? _number;
  // ignore: unused_field
  String? _email;

  User({
    String? nm,
    String? pwd,
    String? num,
    String? mail,
    bool? blk = false,
    bool? adm = false,
    int? ids = -1,
  }) {
    _name = nm;
    _password = pwd;
    _isAdmin = adm;
    _isBlock = blk;
    _id = ids;
    _number = num;
    _email = mail;
  }

  int getId() {
    return _id!;
  }

  String show() {
    return _name!;
  }

  bool isBlocked() {
    return _isBlock!;
  }

  bool isAdmin() {
    return _isAdmin!;
  }

  bool isEmpty() {
    if (_id == -1) {
      return true;
    } else {
      return false;
    }
  }

  void setPass(String p) {
    _id = int.parse(p);
  }

  String getName() {
    return _name!;
  }

  String getPass() {
    return _password!;
  }

  static Future<List<User>> allUsers() async {
    try {
      List<dynamic> res = await Query.execute(query: Query.allUserMaster);
      List<User> userlist = res.map((e) => User.fromServer(e)).toList();
      return userlist;
    } catch (e) {
      print(e);
      return [];
    }
  }

  factory User.fromServer(Map<String, dynamic> server) {
    final _isAdm = server['isadmin'];
    // final _isBlk = server['isblock'];

    switch (_isAdm) {
      case true:
        return Admin(
          name: server['usr_nm'] as String,
          pass: server['pwd'] as String,
          adim: server['isadmin'] as bool,
          blok: server['isblock'] as bool,
          ids: server['id'],
          numb: server['mobile'] as String,
          mail: server['email'] as String,
        );

      case false:
        return Salesman(
          name: server['usr_nm'] as String,
          pass: server['pwd'] as String,
          adim: server['isadmin'] as bool,
          blok: server['isblock'] as bool,
          ids: server['id'],
          numb: server['mobile'] as String,
          mail: server['email'] as String,
        );

      default:
        return User(
          nm: server['usr_nm'] as String,
          pwd: server['pwd'] as String,
          adm: server['isadmin'] as bool,
          blk: server['isblock'] as bool,
          ids: server['id'],
          num: server['mobile'] as String,
          mail: server['email'] as String,
        );
    }
  }

  save() async {
    try {
      dynamic res = await User.login(username: _name!, password: _password!);
      if (!res['value']) {
        dynamic result = await Query.execute(p1: '1', query: """
        insert into usr_mast(usr_nm,pwd,isadmin,isblock,mobile,email)
        values('$_name','$_password',0,0,'$_number','$_email')
        """);
        if (result['status'] == "success") {
          return {"msg": "User Created Successfully", "value": true};
        } else {
          throw "Error In Saving New User";
        }
      } else {
        throw res['msg'];
      }
    } catch (e) {
      print(e);
      return {"msg": e.toString(), "value": false};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      List<dynamic> res = await Query.execute(
          query:
              "select * from usr_mast where usr_nm = '$username' and pwd = '$password' ");
      if (res.isEmpty) {
        return {'value': false, 'msg': 'No User Found', 'data': null};
      } else if (res.length > 1) {
        return {'value': false, 'msg': 'Multiple Users Found', 'data': null};
      } else {
        User user = User.fromServer(res[0]);
        return {'value': true, 'msg': 'You Are Logged in', 'data': user};
      }
    } catch (e) {
      print(e);
      return {'value': false, 'msg': 'Error Occures While Login', 'data': null};
    }
  }

  ulterAdmin(bool? value) async {
    var result = await Query.execute(
      query: """
        update usr_mast
        set isadmin = ${value == true ? 1 : 0}
        where id = $_id
      """,
      p1: '1',
    );
    return result;
  }

  ulterBlock(bool? value) async {
    var result = await Query.execute(
      query: """
        update usr_mast
        set isblock = ${value == true ? 1 : 0}
        where id = $_id
      """,
      p1: '1',
    );
    return result;
  }

  resetPassword(String? newP) async {
    dynamic check = await User.login(username: _name!, password: _password!);
    if (check['value'] == true) {
      var result = await Query.execute(
        p1: '1',
        query: '''
          update usr_mast
          set pwd = '$newP'
          where usr_nm = '$_name' and pwd = '$_password'
        ''',
      );

      if (result['status'] == 'success') {
        _password = newP;
        return true;
      }
      return false;
    }
    return false;
  }

  display(BuildContext context) {}
  availableOption() {}
}
