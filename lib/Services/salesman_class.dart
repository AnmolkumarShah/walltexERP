import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/Text_check.dart';
import 'package:walltex_app/Screens/MoreOptions/User%20Related/reset_password_screen.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/control.dart';

class Salesman extends User {
  String? nm;
  String? pwd;
  bool? blk;
  bool? adm = false;
  int? id;
  Salesman({
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
          tileColor: blk == true ? Colors.redAccent : Colors.lightBlue[100],
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
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCheck(label: "Admin", value: adm, cbkfun: ulterAdmin),
              TextCheck(
                label: "Blocked",
                value: blk,
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
    ];
    return list;
  }
}
