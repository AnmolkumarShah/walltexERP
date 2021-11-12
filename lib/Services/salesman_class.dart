import 'package:walltex_app/Services/user_class.dart';

class Salesman extends User {
  Salesman({String? nm, String? pwd, bool? blk, bool? adm = false})
      : super(nm: nm, pwd: pwd, adm: adm, blk: blk);
}
