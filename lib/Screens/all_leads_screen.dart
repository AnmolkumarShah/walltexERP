import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Widgets/lead_tile.dart';

class AllLeads extends StatefulWidget {
  const AllLeads({Key? key}) : super(key: key);

  @override
  State<AllLeads> createState() => _AllLeadsState();
}

class _AllLeadsState extends State<AllLeads> {
  static int count = 0;
  List<dynamic> data = [];
  List<dynamic> filteredData = [];
  List<Map<String, Object>> extraOptionItems = [
    {'name': "All Leads"},
    {'name': "Gained Leads"},
    {'name': "Lost Leads"},
    {'name': "Pending Leads"},
    {'name': "Sort By Creation Date"},
    {'name': "Sort By Next Followup Date"},
  ];

  String? _selectedExtraOption;

  filterData(String s) {
    switch (s) {
      case "Gained Leads":
        List<dynamic> temp = data.where((e) => e['ordergain'] == true).toList();
        setState(() {
          filteredData = temp;
          _selectedExtraOption = s;
        });
        break;
      case "Lost Leads":
        List<dynamic> temp = data.where((e) => e['orderlost'] == true).toList();
        setState(() {
          filteredData = temp;
          _selectedExtraOption = s;
        });
        break;
      case "Pending Leads":
        List<dynamic> temp = data
            .where((e) => (e['orderlost'] == false && e['ordergain'] == false))
            .toList();
        setState(() {
          filteredData = temp;
          _selectedExtraOption = s;
        });
        break;
      case "All Leads":
        List<dynamic> temp = data;
        setState(() {
          filteredData = temp;
          _selectedExtraOption = s;
        });
        break;
      case "Sort By Creation Date":
        List<dynamic> temp = data;
        temp.sort((a, b) => onlyDateFromDataBase(a['leaddate'])
            .compareTo(onlyDateFromDataBase(b['leaddate'])));
        setState(() {
          filteredData = temp;
          _selectedExtraOption = s;
        });
        break;
      case "Sort By Next Followup Date":
        List<dynamic> temp =
            data.where((e) => e['nextfollowupon'] != null).toList();
        temp.sort((a, b) => onlyDateFromDataBase(a['nextfollowupon'])
            .compareTo(onlyDateFromDataBase(b['nextfollowupon'])));
        setState(() {
          filteredData = temp;
          _selectedExtraOption = s;
        });
        break;
    }
  }

  getSet() async {
    List<dynamic> result = await Query.execute(query: " select * from leads ");
    setState(() {
      data = result;
    });
  }

  init() async {
    if (count > 0) return;
    _selectedExtraOption = extraOptionItems.first['name'].toString();
    await getSet();
    filterData(_selectedExtraOption!);
    count++;
  }

  @override
  void initState() {
    super.initState();
    count = 0;
  }

  @override
  void didUpdateWidget(covariant AllLeads oldWidget) {
    super.didUpdateWidget(oldWidget);
    print(_selectedExtraOption);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    count = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Leads"),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _selectedExtraOption,
              iconSize: 40,
              onChanged: (s) {
                filterData(s.toString());
              },
              dropdownColor: Theme.of(context).colorScheme.primary,
              style: TextStyle(color: Colors.white),
              items: extraOptionItems
                  .map((e) => DropdownMenuItem(
                        value: e['name'],
                        child: Text(e['name'].toString()),
                        onTap: () {},
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader.circular;
          }
          return ListView.builder(
            itemCount: filteredData.length,
            itemBuilder: (context, index) => LeadTile(
              data: filteredData[index],
            ),
          );
        },
      ),
    );
  }
}
