import 'package:walltex_app/Helpers/querie.dart';

class Lead {
  int? sman;
  String? name;
  String? address;
  String? place;
  String? mobile;
  String? email;
  String? dob;
  String? anniv;
  String? material;
  String? remark;
  String? leaddate;

  int? reffId;
  int? prod1;
  int? prod2;
  int? prod3;
  int? prod4;
  int? prod5;
  int? prod6;

  double? lat;
  double? log;

  String? nextfollowupon;
  String? nextfollowuprem;
  int? ordergain;
  int? orderlost;
  String? gaindetails;
  String? lostdetails;

  Lead({
    this.address,
    this.anniv,
    this.dob,
    this.email,
    this.material,
    this.mobile,
    this.name,
    this.place,
    this.prod1,
    this.prod2,
    this.prod3,
    this.prod4,
    this.prod5,
    this.prod6,
    this.reffId,
    this.remark,
    this.lat,
    this.log,
    this.leaddate,
    this.sman,
    this.gaindetails = "",
    this.lostdetails = "",
    this.nextfollowupon = "",
    this.nextfollowuprem = "",
    this.ordergain = 0,
    this.orderlost = 0,
  });

  Future getId(Lead lead) async {
    try {
      dynamic res = await Query.execute(query: """
      select id from leads where Name = '${lead.name}' and address = '${lead.address}' and place = '${lead.place}'
      """);
      return res[0]['id'];
    } catch (e) {
      return -1;
    }
  }

  static Future getLead(int id) async {
    try {
      dynamic res = await Query.execute(query: """
      select * from leads where id = $id
      """);
      return res[0];
    } catch (e) {
      print(e);
    }
  }

  Future update(String id) async {
    try {
      final res = await Query.execute(
        p1: '1',
        query: """
        update leads set
        sman = $sman,Name = '$name',address = '$address',place = '$place',
        Mobile = '$mobile',email = '$email',dob = '$dob',anniv = '$anniv',
        product1 =  $prod1,product2 = $prod2,product3 = $prod3,
        product4 = $prod4,product5 = $prod5,product6 = $prod6,
        material = '$material',remarks = '$remark',leaddate = '$leaddate',
        lat = $lat,long = $log,ref = $reffId,nextfollowuprem = '$nextfollowuprem',
        ordergain = $ordergain,gaindetails = '$gaindetails',orderlost = $orderlost,
        lostdetails = '$lostdetails'
        where id = $id
        """,
      );
      print(res);
      if (res['status'] == 'success') {
        return {'value': true, 'msg': "Lead Updated Successfully"};
      } else {
        throw "Error In Lead saving";
      }
    } catch (e) {
      return {'value': false, 'msg': e.toString()};
    }
  }

  Future save() async {
    try {
      final res = await Query.execute(
        p1: '1',
        query: """

        insert into leads(sman,Name,address,place,Mobile,email,dob,anniv,
        product1,product2,product3,product4,product5,product6,material,
        remarks,leaddate,lat,long,ref,nextfollowuprem,ordergain,gaindetails,orderlost,
        lostdetails)
        values($sman,'$name','$address','$place','$mobile','$email','$dob','$anniv',
        $prod1,$prod2,$prod3,$prod4,$prod5,$prod6,'$material','$remark','$leaddate',
        $lat,$log,$reffId,'$nextfollowuprem',$ordergain,'$gaindetails',$orderlost,'$lostdetails')

        """,
      );

      int leadId = await getId(this);

      final followupres = await Query.execute(
        p1: '1',
        query: """

        insert into followup(followupdt,leadid,sman,leadremarks,nextdate,nextrem,
        isdone,isdoneid,lat,long)
        values('$leaddate',$leadId,$sman,'$remark','$leaddate','',0,$sman,$lat,$log)

        """,
      );

      if (res['status'] == 'success' && followupres['status'] == 'success') {
        return {'value': true, 'msg': "Lead Saved Successfully"};
      } else {
        throw "Error In Lead saving";
      }
    } catch (e) {
      return {'value': false, 'msg': e.toString()};
    }
  }
}
