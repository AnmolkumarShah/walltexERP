import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/Text_check.dart';
import 'package:walltex_app/Screens/add_user_screen.dart';
import 'package:walltex_app/Screens/lead_entry_screen.dart';
import 'package:walltex_app/Screens/product_entry_screen.dart';
import 'package:walltex_app/Screens/references_entry_screen.dart';
import 'package:walltex_app/Screens/reset_password_screen.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/control.dart';

class Admin extends User {
  String? nm;
  String? pwd;
  bool? blk;
  bool? adm = false;
  int? id;
  Admin({
    String? name,
    String? pass,
    bool? blok,
    bool? adim = false,
    int? ids = -1,
  }) : super(nm: name, pwd: pass, adm: adim, blk: blok, ids: ids) {
    nm = name;
    pwd = pass;
    blk = blok;
    adm = adim;
    id = ids;
  }

  bool? isblock() {
    return blk!;
  }

  @override
  display(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                forUser: this,
              ),
            ),
          );
        },
        child: ListTile(
          tileColor:
              // ignore: unrelated_type_equality_checks
              isblock == true ? Colors.redAccent : Colors.amber[100],
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Name : " + nm!,
                  style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                // Text(
                //   "Id  : " + .toString(),
                //   style: const TextStyle(fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCheck(
                label: "Admin",
                value: adm,
                // cbkfun: this.ulterAdmin,
                cbkfun: ulterAdmin,
              ),
              TextCheck(
                label: "Blocked",
                value: blk,
                // cbkfun: this.ulterBlock,
                cbkfun: ulterBlock,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  List<Map<String, dynamic>> availableOption() {
    List<Map<String, dynamic>> list = [
      Control.leadScreen,
      Control.addUserScreen,
      Control.productScreen,
      Control.referenceScreen,
    ];
    return list;
  }
}
