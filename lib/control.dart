import 'package:walltex_app/Screens/add_user_screen.dart';
import 'package:walltex_app/Screens/lead_entry_screen.dart';
import 'package:walltex_app/Screens/product_entry_screen.dart';
import 'package:walltex_app/Screens/references_entry_screen.dart';

class Control {
  static Map<String, Object> leadScreen = {
    "name": "Lead Entry",
    "value": const LeadEntryScreen(),
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
}
