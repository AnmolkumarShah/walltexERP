import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/date_selected_helper.dart';
import 'package:walltex_app/Helpers/drop_down_helper.dart';
import 'package:walltex_app/Helpers/format_date.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Providers/control_provider.dart';
import 'package:walltex_app/Services/Model_Interface.dart';
import 'package:walltex_app/Screens/Tash%20Related/all_task_screen.dart';
import 'package:walltex_app/Services/lead_model.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/product_class.dart';
import 'package:walltex_app/Services/references_class.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/Widgets/lead_tile.dart';
import 'package:walltex_app/control.dart';

class LeadEntryScreen extends StatefulWidget {
  int? madeLead;
  bool? taskShow = true;
  LeadEntryScreen({Key? key, this.madeLead, this.taskShow}) : super(key: key);

  @override
  State<LeadEntryScreen> createState() => _LeadEntryScreenState();
}

class _LeadEntryScreenState extends State<LeadEntryScreen> {
  static int count = 0;
  List<Product>? productItems;
  List<References>? referencesItems;

  Product? _prod1, _prod2, _prod3, _prod4, _prod5, _prod6;
  References? _selectedReference;
  List<User>? _users;
  User? _selectedUser;

  bool? loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    count = 0;
  }

  @override
  void initState() {
    super.initState();
    count = 0;
  }

  Future init() async {
    List<Product> pItems = await Query.fetch(Product());
    List<References> rItems = await Query.fetch(References());

    List<User>? userList = await User.allUsers();

    pItems.insert(0, Product(id: -1, desc: "Select Product"));
    rItems.insert(0, References(id: -1, desc: "Select References"));
    userList.insert(0, User(ids: -1, nm: "Select User"));

    setState(() {
      productItems = pItems;
      referencesItems = rItems;

      _users = userList;

      _prod1 = pItems.first;
      _prod2 = pItems.first;
      _prod3 = pItems.first;
      _prod4 = pItems.first;
      _prod5 = pItems.first;
      _prod6 = pItems.first;
      _selectedReference = rItems.first;
      _selectedUser = userList.first;
    });
    if (widget.madeLead != null) {
      await getSet(widget.madeLead!);
    }
    return;
  }

  _fetchData() async {
    if (count > 0) return;
    await init();
    count++;
  }

  final Input _name = Input(label: "Name");
  final Input _address = Input(label: "Address");
  final Input _place = Input(label: "Place");
  final Input _mobile = Input.number(label: "Mobile Number without +91");
  final Input _email = Input.email(label: "Email");
  final MyDate _anniv = MyDate(label: "Anniv");
  final Input _material = Input(label: "Material");
  final Input _remark = Input(label: "Remark");
  final MyDate _dob = MyDate(label: "Select DOB");

  bool check() {
    if (_dob.isEmpty()) {
      showSnakeBar(context, "Select A Valid DOB");
      return false;
    } else if (_anniv.isEmpty()) {
      showSnakeBar(context, "Select A Valid Anniversary Date");
      return false;
    } else if (_name.isEmpty() ||
        _address.isEmpty() ||
        _place.isEmpty() ||
        _mobile.isEmpty() ||
        _email.isEmpty() ||
        _selectedUser!.isEmpty() ||
        _selectedReference!.isEmpty()) {
      showSnakeBar(context, "Enter All Fields Properly");
      return false;
    } else {
      return true;
    }
  }

  update(User _curUser) async {
    double? lat;
    double? lon;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      lon = position.longitude;
    } catch (e) {
      lat = 0.0;
      lon = 0.0;
    }

    Lead lead = Lead(
      sman: _selectedUser!.getId(),
      address: _address.value(),
      anniv: formateDate(_anniv.value()),
      dob: formateDate(_dob.value()),
      email: _email.value(),
      lat: lat,
      log: lon,
      material: _material.value(),
      mobile: _mobile.value(),
      name: _name.value(),
      place: _place.value(),
      prod1: _prod1!.value(),
      prod2: _prod2!.value(),
      prod3: _prod3!.value(),
      prod4: _prod4!.value(),
      prod5: _prod5!.value(),
      prod6: _prod6!.value(),
      reffId: _selectedReference!.value(),
      remark: _remark.value(),
      leaddate: formateDate(DateTime.now()),
    );
    setState(() {
      loading = true;
    });
    dynamic res = await lead.update(widget.madeLead.toString());
    if (res['value'] == true) {
      showSnakeBar(context, res['msg']);
      Navigator.pop(context);
    } else {
      showSnakeBar(context, res['msg']);
    }
    setState(() {
      loading = false;
    });
  }

  save(User _curUser) async {
    double? lat;
    double? lon;

    // if user is not admin, then its own id will be saved into sman
    if (!_curUser.isAdmin()) {
      setState(() {
        _selectedUser = _curUser;
      });
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      lon = position.longitude;
    } catch (e) {
      lat = 0.0;
      lon = 0.0;
    }
    if (check()) {
      Lead lead = Lead(
        sman: _selectedUser!.getId(),
        address: _address.value(),
        anniv: formateDate(_anniv.value()),
        dob: formateDate(_dob.value()),
        email: _email.value(),
        lat: lat,
        log: lon,
        material: _material.value(),
        mobile: _mobile.value(),
        name: _name.value(),
        place: _place.value(),
        prod1: _prod1!.value(),
        prod2: _prod2!.value(),
        prod3: _prod3!.value(),
        prod4: _prod4!.value(),
        prod5: _prod5!.value(),
        prod6: _prod6!.value(),
        reffId: _selectedReference!.value(),
        remark: _remark.value(),
        leaddate: formateDate(DateTime.now()),
      );
      setState(() {
        loading = true;
      });
      dynamic res = await lead.save();
      if (res['value'] == true) {
        showSnakeBar(context, res['msg']);
        Navigator.pop(context);
      } else {
        showSnakeBar(context, res['msg']);
      }
      setState(() {
        loading = false;
      });
    } else {
      // showSnakeBar(context, "Enter All Fields Properly");
    }
  }

  getSet(int id, {bool noProduct = false}) async {
    dynamic res = await Lead.getLead(id);
    _name.setValue(res['Name']);
    _address.setValue(res['address']);
    _place.setValue(res['place']);
    _mobile.setValue(res['Mobile']);
    _email.setValue(res['email']);
    _address.setValue(res['address']);

    _anniv.setValue(res['anniv']);
    _dob.setValue(res['dob']);

//  only at time of auto fillup with mobile number
    if (noProduct == false) {
      _prod1 = productItems!.firstWhere((e) => e.getId() == res['product1']);
      _prod2 = productItems!.firstWhere((e) => e.getId() == res['product2']);
      _prod3 = productItems!.firstWhere((e) => e.getId() == res['product3']);
      _prod4 = productItems!.firstWhere((e) => e.getId() == res['product4']);
      _prod5 = productItems!.firstWhere((e) => e.getId() == res['product5']);
      _prod6 = productItems!.firstWhere((e) => e.getId() == res['product6']);

      _remark.setValue(res['remarks']);
      _material.setValue(res['material']);
    }

    _selectedReference =
        referencesItems!.firstWhere((e) => e.getId() == res['ref']);
    _selectedUser = _users!.firstWhere((e) => e.getId() == res['sman']);
    setState(() {});
  }

  // previous lead info
  moreInfoFromNumber() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: Query.execute(
              query:
                  "select * from leads where Mobile = '${_mobile.value()}' "),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader.circular;
            }
            List<dynamic> data = snapshot.data as List<dynamic>;

            if (data.isEmpty) {
              return Container(
                padding: EdgeInsets.all(20),
                color: Colors.amber,
                child: Text("No Previous Leads Whith this number"),
              );
            }
            getSet(data[0]['id'], noProduct: true);
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text("Previous Leads With this Number",
                      style: Control.eventStyle),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.green,
                        child: Text("Gained", textAlign: TextAlign.center),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.greenAccent[200],
                        child: Text("Pending", textAlign: TextAlign.center),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.red,
                        child: Text("Lost", textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => LeadTile(
                      data: data[index],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User _currUser =
        Provider.of<ControlProvider>(context, listen: false).getUser();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.madeLead == null
            ? Control.leadScreen['name'].toString()
            : "Lead Details"),
        actions: [
          widget.madeLead != null && widget.taskShow == true
              ? TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllTaskScreen(leadId: widget.madeLead!),
                      ),
                    );
                  },
                  icon: const Icon(Icons.select_all, color: Colors.white),
                  label:
                      const Text("Task", style: TextStyle(color: Colors.white)),
                )
              : const SizedBox(width: 0)
        ],
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader.circular;
          }

          return SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    widget.madeLead != null
                        ? Chip(
                            label: Text(
                                "Date Created : ${dateFormat(_dob.value())}"),
                          )
                        : const SizedBox(width: 0),
                    FocusScope(
                      onFocusChange: (v) {
                        if (!v) {
                          moreInfoFromNumber();
                        }
                      },
                      child: _mobile.builder(),
                    ),
                    _name.builder(),
                    Dropdown<Model>(
                      selected: _selectedReference,
                      items: referencesItems,
                      fun: (val) {
                        setState(() {
                          _selectedReference = val;
                        });
                      },
                      label: "References",
                    ).build(),
                    _currUser.isAdmin() == true
                        ? Dropdown<User>(
                            selected: _selectedUser,
                            items: _users,
                            fun: (val) {
                              setState(() {
                                _selectedUser = val;
                              });
                            },
                            label: "Assigned To",
                          ).build()
                        : const SizedBox(
                            height: 0,
                          ),
                    _address.builder(),
                    _place.builder(),
                    _email.builder(),
                    _dob.builder(),
                    _anniv.builder(),
                    Dropdown(
                      selected: _prod1,
                      items: productItems,
                      fun: (val) {
                        setState(() {
                          _prod1 = val;
                        });
                      },
                      label: "Product 1",
                    ).build(),
                    Dropdown<Model>(
                      selected: _prod2,
                      items: productItems,
                      fun: (val) {
                        setState(() {
                          _prod2 = val;
                        });
                      },
                      label: "Product 2",
                    ).build(),
                    Dropdown<Model>(
                      selected: _prod3,
                      items: productItems,
                      fun: (val) {
                        setState(() {
                          _prod3 = val;
                        });
                      },
                      label: "Product 3",
                    ).build(),
                    Dropdown<Model>(
                      selected: _prod4,
                      items: productItems,
                      fun: (val) {
                        setState(() {
                          _prod4 = val;
                        });
                      },
                      label: "Product 4",
                    ).build(),
                    Dropdown<Model>(
                      selected: _prod5,
                      items: productItems,
                      fun: (val) {
                        setState(() {
                          _prod5 = val;
                        });
                      },
                      label: "Product 5",
                    ).build(),
                    Dropdown<Model>(
                      selected: _prod6,
                      items: productItems,
                      fun: (val) {
                        setState(() {
                          _prod6 = val;
                        });
                      },
                      label: "Product 6",
                    ).build(),
                    _material.builder(),
                    _remark.builder(),
                    loading == true
                        ? Loader.circular
                        : widget.taskShow == true
                            ? (widget.madeLead == null
                                ? ElevatedButton(
                                    onPressed: () => save(_currUser),
                                    child: const Text("Save"),
                                  )
                                : ElevatedButton(
                                    onPressed: () => update(_currUser),
                                    child: const Text("Update"),
                                  ))
                            : const SizedBox(height: 0),
                  ],
                ),
                loading == true
                    ? AlertDialog(
                        title: const Text("Loading..."),
                        content: CircularProgressIndicator(),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
