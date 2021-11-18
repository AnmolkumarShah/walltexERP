
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Providers/control_provider.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/Widgets/followup_tile.dart';
import 'package:walltex_app/Widgets/option_tile.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

fetchFollowUp() async {
  String query = """
  select a.id,b.Name, b.place,b.mobile,b.remarks,
  c.usr_nm as SalesMan, a.nextdate,a.nextrem ,a.leadid
  from followup a
  left join leads b on a.leadid = b.id
  left join usr_mast c on a.sman = c.id
  where a.isdone  = 0 and a.nextdate <= getdate()  
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
    User? currentUser =
        Provider.of<ControlProvider>(context, listen: false).getUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Column(
        children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 2.5,
            ),
            shrinkWrap: true,
            itemCount: currentUser.availableOption().length,
            itemBuilder: (context, index) {
              final val = currentUser.availableOption();
              return OptionTile(
                title: val[index]['name'],
                next: val[index]['value'],
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
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
                future: fetchFollowUp(),
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
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
