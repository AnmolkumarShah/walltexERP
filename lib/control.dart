import 'package:flutter/material.dart';
import 'package:walltex_app/Screens/add_user_screen.dart';
import 'package:walltex_app/Screens/anniv_screen.dart';
import 'package:walltex_app/Screens/birthday_screen.dart';
import 'package:walltex_app/Screens/gained_lead_screen.dart';
import 'package:walltex_app/Screens/lead_entry_screen.dart';
import 'package:walltex_app/Screens/lost_lead_screen.dart';
import 'package:walltex_app/Screens/product_entry_screen.dart';
import 'package:walltex_app/Screens/references_entry_screen.dart';

class Control {
  static Map<String, Object> leadScreen = {
    "name": "Lead Entry",
    "value": LeadEntryScreen(),
  };

  static Map<String, Object> addUserScreen = {
    "name": "Add User",
    "value": const AddUser(),
  };

  static Map<String, Object> productScreen = {
    "name": "Product Master",
    "value": const ProductEntryScreen(),
  };

  static Map<String, Object> referenceScreen = {
    "name": "Refferance Master",
    "value": const ReferenceEntryScreen(),
  };

  static Map<String, Object> gainedLeadScreen = {
    "name": "Gained Leads",
    "value": const GainedLEad(),
  };

  static Map<String, Object> birthdayScreen = {
    "name": "Birthday Screen",
    "value": const BirthdayScreen(),
  };

  static Map<String, Object> annivScreen = {
    "name": "Anniversary Screen",
    "value": const AnnivScreen(),
  };

  static Map<String, Object> lostLeadScreen = {
    "name": "Lost Leads",
    "value": const LostLead(),
  };

  static Widget myEnvolop(Color? color, Widget child,{double padding = 10}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  static TextStyle eventStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 15,
  );

  static TextStyle onlybold = TextStyle(
    fontWeight: FontWeight.bold,
  );
}
