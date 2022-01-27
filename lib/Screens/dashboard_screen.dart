import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walltex_app/Helpers/birthday_today.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Providers/control_provider.dart';
import 'package:walltex_app/Screens/Initail%20Process/login_screen.dart';
import 'package:walltex_app/Screens/Task%20Related/assigned_task.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/Widgets/followup_tile.dart';
import 'package:walltex_app/control.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

fetchFollowUp(int id, {required bool isAdmin}) async {
  String query = """
  select a.id,b.Name, b.place,b.mobile,b.remarks,
  c.usr_nm as SalesMan, a.nextdate,a.nextrem ,a.leadid
  from followup a
  left join leads b on a.leadid = b.id
  left join usr_mast c on a.sman = c.id
  where a.isdone  = 0 and a.nextdate <= getdate() ${isAdmin == true ? "" : "and a.sman = $id"} 
  order by a.id desc
  """;
  try {
    dynamic res = await Query.execute(query: query);
    return res;
  } catch (e) {
    print(e);
  }
}

class _DashboardState extends State<Dashboard> {
  refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> extraOptionItems = [];

    extraOptionItems.add(Control.addUserScreen);
    extraOptionItems.add(Control.productScreen);
    extraOptionItems.add(Control.referenceScreen);
    // extraOptionItems.add(Control.gainedLeadScreen);
    extraOptionItems.add(Control.birthdayScreen);
    extraOptionItems.add(Control.annivScreen);
    extraOptionItems.add(Control.allLeadScreen);
    // extraOptionItems.add(Control.lostLeadScreen);
    extraOptionItems.add(Control.followupTypeScreen);
    extraOptionItems.add(Control.taskTypeScreen);

    User? currentUser =
        Provider.of<ControlProvider>(context, listen: false).getUser();
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Logout Of Application"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Dashboard"),
        elevation: 0,
        actions: currentUser.isAdmin() == true
            ? [
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: extraOptionItems.first['name'].toString(),
                    iconSize: 40,
                    onChanged: (s) {
                      var data = s;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => extraOptionItems.firstWhere(
                              (e) =>
                                  e['name'].toString() ==
                                  data.toString())['value'] as Widget,
                        ),
                      );
                    },
                    dropdownColor: Theme.of(context).colorScheme.primary,
                    style: TextStyle(color: Colors.white),
                    items: extraOptionItems
                        .map((e) => DropdownMenuItem(
                              value: e['name'].toString(),
                              child: Text(e['name'].toString()),
                              onTap: () {},
                            ))
                        .toList(),
                  ),
                ),
              ]
            : [],
      ),
      body: Column(
        children: [
          BirthDayToday(id: currentUser.getId()),
          AssignedTask(isAll: currentUser.isAdmin()),
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: const [
                  Text(
                    "All Pending Followup By Today",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Swipe Down To Refresh",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => refresh(),
              child: FutureBuilder(
                future: fetchFollowUp(currentUser.getId(),
                    isAdmin: currentUser.isAdmin()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loader.circular;
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Chip(label: Text("Error Occured")),
                    );
                  }
                  dynamic data = snapshot.data;
                  if (data.length == 0) {
                    return const Center(
                      child: Chip(label: Text("No Followups")),
                    );
                  }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => FollowupTile(
                      data: data[index],
                      refresh: refresh,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Control.leadScreen['value'] as Widget,
            ),
          );
          refresh();
        },
        label: Row(
          children: [
            Icon(Icons.add_box_outlined),
            const SizedBox(
              width: 10,
            ),
            Text(Control.leadScreen['name'].toString()),
          ],
        ),
      ),
    );
  }
}
