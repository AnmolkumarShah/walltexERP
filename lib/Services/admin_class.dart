import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/Text_check.dart';
import 'package:walltex_app/Screens/MoreOptions/User%20Related/reset_password_screen.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/control.dart';

class Admin extends User {
  String? nm;
  String? pwd;
  bool? blk;
  bool? adm = false;
  int? id;
  String? number;
  String? email;
  Admin({
    String? name,
    String? pass,
    bool? blok,
    String? numb,
    String? mail,
    bool? adim = false,
    int? ids = -1,
  }) : super(
            nm: name,
            pwd: pass,
            adm: adim,
            blk: blok,
            ids: ids,
            num: numb,
            mail: mail) {
    nm = name;
    pwd = pass;
    blk = blok;
    adm = adim;
    id = ids;
    number = numb;
    email = mail;
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
            child: Column(
              children: [
                Row(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email : " + email!,
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mobile : " + number!,
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
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
      Control.gainedLeadScreen,
      Control.lostLeadScreen,
      Control.birthdayScreen,
      Control.annivScreen,
    ];
    return list;
  }
}
