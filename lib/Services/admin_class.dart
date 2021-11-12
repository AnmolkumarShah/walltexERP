import 'package:walltex_app/Services/user_class.dart';

class Admin extends User {
  Admin({String? nm, String? pwd, bool? blk, bool? adm = false})
      : super(nm: nm, pwd: pwd, adm: adm, blk: blk);
}
