// all supporting queries

import 'dart:convert';
import 'package:walltex_app/Helpers/network.dart';
import 'package:walltex_app/Helpers/url_model.dart';

class Query {
  static const allUserMaster = "select * from  usr_mast";

  // method for all  query language commands
  static Future execute({String? query, String? p1 = '0'}) async {
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
}
