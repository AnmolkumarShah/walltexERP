import 'package:walltex_app/Providers/compony_selector_singleton.dart';

class UrlGlobal {
  // example
  // http://167.114.35.29/sfs_api/bill.asmx/apierp ? p=2 & p1=0 & p2=select * from usr_mast where id = 1&tblno=&cid=&yr=&xdt=&serno=
  late String host;
  late String p;
  late String p1;
  late String p2;
  late String last;

  // UrlGlobal({
  //   this.host = "http://167.114.35.29/sfs_api/bill.asmx/apierp",
  //   this.p,
  //   this.p1 = '0',
  //   this.p2 = "",
  //   this.last = "tblno=&cid=&yr=&xdt=&serno=",
  // });

  UrlGlobal({
    String? host,
    String? p,
    String? p1 = '0',
    String? p2 = "",
    String? last,
  }) {
    String temp = CompanySelector().getId();
    this.host = "http://167.114.35.29/sfs_api/bill.asmx/apierp";
    this.p = temp;
    this.p1 = p1!;
    this.p2 = p2!;
    this.last = "tblno=&cid=&yr=&xdt=&serno=";
  }

  // -------------------------------------------------

  String ampersand() {
    return '&';
  }

  String questionMark() {
    return '?';
  }

  //-------------------------------------

  void setHost(String host) {
    this.host = host;
  }

  void setP1(String value) {
    p1 = value;
  }

  String getP1() {
    return "p1=$p1";
  }

  String getP() {
    return "p=$p";
  }

  void setP(value) {
    p = value;
  }

  void setP2(value) {
    p2 = value;
  }

  String getP2() {
    return "p2=$p2";
  }

  void setLast(String value) {
    last = value;
  }

  String getLast() {
    return last;
  }

  String getUrl() {
    return "$host${questionMark()}${getP()}${ampersand()}${getP1()}${ampersand()}${getP2()}${ampersand()}${getLast()}";
  }

  String fileUploadUrl() {
    return host;
  }
}
