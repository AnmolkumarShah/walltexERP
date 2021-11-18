import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:walltex_app/Helpers/date_selected_helper.dart';
import 'package:walltex_app/Helpers/drop_down_helper.dart';
import 'package:walltex_app/Helpers/format_date.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Providers/control_provider.dart';
import 'package:walltex_app/Services/Model_Interface.dart';
import 'package:walltex_app/Services/lead_model.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/product_class.dart';
import 'package:walltex_app/Services/references_class.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/control.dart';

class LeadEntryScreen extends StatefulWidget {
  int? madeLead;
  LeadEntryScreen({Key? key, this.madeLead}) : super(key: key);

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
  final Input _mobile = Input.number(label: "Mobile");
  final Input _email = Input.email(label: "Email");
  final MyDate _anniv = MyDate(label: "Anniv");
  final Input _material = Input(label: "Material");
  final Input _remark = Input(label: "Remark");
  final MyDate _dob = MyDate(label: "Select DOB");

  bool check() {
    if (_name.isEmpty() ||
        _address.isEmpty() ||
        _place.isEmpty() ||
        _mobile.isEmpty() ||
        _email.isEmpty() ||
        _anniv.isEmpty() ||
        _material.isEmpty() ||
        _remark.isEmpty() ||
        (_prod1!.isEmpty() &&
            _prod2!.isEmpty() &&
            _prod3!.isEmpty() &&
            _prod4!.isEmpty() &&
            _prod5!.isEmpty() &&
            _prod6!.isEmpty()) ||
        _selectedUser!.isEmpty() ||
        _selectedReference!.isEmpty() ||
        _dob.isEmpty()) {
      return false;
    } else {
      return true;
    }
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
      showSnakeBar(context, "Enter All Fields Properly");
    }
  }

  getSet(int id) async {
    dynamic res = await Lead.getLead(id);
    _name.setValue(res['Name']);
    _address.setValue(res['address']);
    _place.setValue(res['place']);
    _mobile.setValue(res['Mobile']);
    _email.setValue(res['email']);
    _address.setValue(res['address']);
    _remark.setValue(res['remarks']);
    _material.setValue(res['material']);
    _anniv.setValue(res['anniv']);
    _dob.setValue(res['dob']);

    _prod1 = productItems!.firstWhere((e) => e.getId() == res['product1']);
    _prod2 = productItems!.firstWhere((e) => e.getId() == res['product2']);
    _prod3 = productItems!.firstWhere((e) => e.getId() == res['product3']);
    _prod4 = productItems!.firstWhere((e) => e.getId() == res['product4']);
    _prod5 = productItems!.firstWhere((e) => e.getId() == res['product5']);
    _prod6 = productItems!.firstWhere((e) => e.getId() == res['product6']);
    _selectedReference =
        referencesItems!.firstWhere((e) => e.getId() == res['ref']);
    _selectedUser = _users!.firstWhere((e) => e.getId() == res['sman']);
    setState(() {});
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
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader.circular;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
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
                        label: "Select User",
                      ).build()
                    : const SizedBox(
                        height: 0,
                      ),
                _address.builder(),
                _place.builder(),
                _mobile.builder(),
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
                    : widget.madeLead == null
                        ? ElevatedButton(
                            onPressed: () => save(_currUser),
                            child: const Text("Save"),
                          )
                        : const SizedBox(
                            width: 0,
                          ),
              ],
            ),
          );
        },
      ),
    );
  }
}
