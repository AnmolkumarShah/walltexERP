import 'package:walltex_app/Helpers/querie.dart';

class Lead {
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
  });

  Future save() async {
    try {
      final res = await Query.execute(
        p1: '1',
        query: """

        insert into leads(sman,Name,address,place,Mobile,email,dob,anniv,
        product1,product2,product3,product4,product5,product6,material,
        remarks,leaddate,lat,long)
        values(0,'$name','$address','$place','$mobile','$email','$dob','$anniv',
        $prod1,$prod2,$prod3,$prod4,$prod5,$prod6,'$material','$remark','$leaddate',$lat,$log)

        """,
      );

      print(res);
    } catch (e) {
      print(e);
    }
  }
}
