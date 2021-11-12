import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/admin_class.dart';
import 'package:walltex_app/Services/salesman_class.dart';

class User {
  int? _id;
  String? _name;
  String? _password;
  bool? _isAdmin;
  bool? _isBlock;

  User({String? nm, String? pwd, bool? blk, bool? adm = false}) {
    _name = nm;
    _password = pwd;
    _isAdmin = adm;
    _isBlock = blk;
  }

  factory User.fromServer(Map<String, dynamic> server) {
    final _isAdm = server['isadmin'];
    // final _isBlk = server['isblock'];

    switch (_isAdm) {
      case true:
        return Admin(
          nm: server['usr_nm'] as String,
          pwd: server['pwd'] as String,
          adm: server['isadmin'] as bool,
          blk: server['isblock'] as bool,
        );

      case false:
        return Salesman(
          nm: server['usr_nm'] as String,
          pwd: server['pwd'] as String,
          adm: server['isadmin'] as bool,
          blk: server['isblock'] as bool,
        );

      default:
        return User(
          nm: server['usr_nm'] as String,
          pwd: server['pwd'] as String,
          adm: server['isadmin'] as bool,
          blk: server['isblock'] as bool,
        );
    }
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      List<dynamic> res = await Query.execute(query: Query.allUserMaster);
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
}
