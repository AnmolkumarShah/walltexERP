// all supporting queries

import 'dart:convert';
import 'package:walltex_app/Helpers/network.dart';
import 'package:walltex_app/Helpers/url_model.dart';
import 'package:walltex_app/Services/Model_Interface.dart';

class Query {
  static const allUserMaster = "select * from  usr_mast";
  static const allReferences = "select * from refferance";
  static const allProduct = "select * from product";
  static const allFollowupType = "select * from followup_type";
  static const allTaskType = "select * from tasktype ";

  // method for all  query language commands
  static Future execute(
      {String? query, String? p1 = '0', bool toPrint = false}) async {
    final UrlGlobal urlObject = UrlGlobal(
      p2: query!,
      p1: p1!,
    );
    try {
      final url = urlObject.getUrl();
      var result = await Network.get(url);
      dynamic data;
      try {
        data = json.decode(result.body) as List<dynamic>;
      } catch (e) {
        data = json.decode(result.body);
      }
      return data;
    } catch (e) {
      return [];
    }
  }

  static Future fetch(Model m) async {
    final UrlGlobal urlObject = UrlGlobal(
      p2: m.getQuery(),
    );

    try {
      final url = urlObject.getUrl();
      var result = await Network.get(url);
      final data = json.decode(result.body) as List<dynamic>;
      result = m.format(data);
      return result;
    } catch (e) {
      return [];
    }
  }
}
