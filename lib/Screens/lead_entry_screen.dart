import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:geolocator/geolocator.dart';
import 'package:walltex_app/Helpers/date_selected_helper.dart';
import 'package:walltex_app/Helpers/drop_down_helper.dart';
import 'package:walltex_app/Helpers/format_date.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Services/lead_model.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/product_class.dart';
import 'package:walltex_app/Services/references_class.dart';
import 'package:walltex_app/control.dart';

class LeadEntryScreen extends StatefulWidget {
  const LeadEntryScreen({Key? key}) : super(key: key);

  @override
  State<LeadEntryScreen> createState() => _LeadEntryScreenState();
}

class _LeadEntryScreenState extends State<LeadEntryScreen> {
  AsyncMemoizer? _memoizer;
  static int count = 0;
  List<Product>? productItems;
  List<References>? referencesItems;
  Product? _prod1, _prod2, _prod3, _prod4, _prod5, _prod6;
  References? _selectedReference;

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

    pItems.insert(0, Product(id: -1, desc: "Select Product"));
    rItems.insert(0, References(id: -1, desc: "Select References"));

    setState(() {
      productItems = pItems;
      referencesItems = rItems;
      _prod1 = pItems.first;
      _prod2 = pItems.first;
      _prod3 = pItems.first;
      _prod4 = pItems.first;
      _prod5 = pItems.first;
      _prod6 = pItems.first;
      _selectedReference = rItems.first;
    });
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
        _prod1!.isEmpty() ||
        _prod2!.isEmpty() ||
        _prod3!.isEmpty() ||
        _prod4!.isEmpty() ||
        _prod5!.isEmpty() ||
        _prod6!.isEmpty() ||
        _selectedReference!.isEmpty() ||
        _dob.isEmpty()) {
      return false;
    } else {
      return true;
    }
  }

  save() async {
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
    if (check()) {
      Lead lead = Lead(
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
      await lead.save();
      setState(() {
        loading = false;
      });
    } else {
      showSnakeBar(context, "Enter All Fields Properly");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Control.leadScreen['name'].toString()),
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
                Dropdown(
                  selected: _selectedReference,
                  items: referencesItems,
                  fun: (val) {
                    setState(() {
                      _selectedReference = val;
                    });
                  },
                  label: "References",
                ).build(),
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
                Dropdown(
                  selected: _prod2,
                  items: productItems,
                  fun: (val) {
                    setState(() {
                      _prod2 = val;
                    });
                  },
                  label: "Product 2",
                ).build(),
                Dropdown(
                  selected: _prod3,
                  items: productItems,
                  fun: (val) {
                    setState(() {
                      _prod3 = val;
                    });
                  },
                  label: "Product 3",
                ).build(),
                Dropdown(
                  selected: _prod4,
                  items: productItems,
                  fun: (val) {
                    setState(() {
                      _prod4 = val;
                    });
                  },
                  label: "Product 4",
                ).build(),
                Dropdown(
                  selected: _prod5,
                  items: productItems,
                  fun: (val) {
                    setState(() {
                      _prod5 = val;
                    });
                  },
                  label: "Product 5",
                ).build(),
                Dropdown(
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
                    : ElevatedButton(
                        onPressed: save, child: const Text("Save")),
              ],
            ),
          );
        },
      ),
    );
  }
}
