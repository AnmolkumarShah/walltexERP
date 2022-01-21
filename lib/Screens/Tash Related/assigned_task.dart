import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Providers/control_provider.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/Widgets/task_type_tile.dart';
import 'package:walltex_app/control.dart';

class AssignedTask extends StatefulWidget {
  const AssignedTask({Key? key}) : super(key: key);

  @override
  State<AssignedTask> createState() => _AssignedTaskState();
}

class _AssignedTaskState extends State<AssignedTask> {
  showModel(BuildContext context, List<dynamic> data) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      builder: (context) {
        return TabView(data: data);
        // return SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.9,
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Chip(label: Text("Your Task")),

        //     ],
        //   ),
        // );
      },
    );
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser =
        Provider.of<ControlProvider>(context, listen: false).getUser();
    return FutureBuilder(
      future: Query.execute(query: """
      select  t.taskid, t.tasktype,t.leadid,t.seqno, t.allotdt,t.started,
      t.complby,t.completed,t.complon,t.rem,t.allotto,
      (select Name from leads where id = t.leadid ) as leadname,
      (select Mobile from leads where id = t.leadid ) as leadnumber,
      (select usr_nm from usr_mast where id = t.allotto)  as allotedto,
      (select task from tasktype where tasktype = t.tasktype) as 
      task from tasks t where t.allotto  = ${currentUser.getId()} 
      order by t.leadid,t.seqno
      """),
      builder: (context, snapshot) {
        if (currentUser.isAdmin()) {
          return const SizedBox(height: 0);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader.linear;
        }
        if (snapshot.hasError) {
          return Text("Error Occured", style: Control.eventStyle);
        }
        List<dynamic> data = snapshot.data as List<dynamic>;
        if (data.isEmpty) {
          return const Center(
            child: Chip(label: Text("No Task Found")),
          );
        }
        return GestureDetector(
          onTap: () => showModel(context, data),
          child: Container(
            padding: EdgeInsets.all(5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            child: Text(
              "You Have Been Assigned To ${data.length} Task\nClick To View Them All",
              textAlign: TextAlign.center,
              style: Control.eventStyle,
            ),
          ),
        );
      },
    );
  }
}

class TabView extends StatelessWidget {
  List<dynamic>? pending;
  List<dynamic>? notStarted;
  List<dynamic>? completed;
  TabView({required List<dynamic>? data}) {
    this.pending = data!
        .where((e) => (e['started'] == true && e['completed'] == false))
        .toList();
    this.notStarted = data
        .where((e) => (e['started'] == false && e['completed'] == false))
        .toList();
    this.completed = data
        .where((e) => (e['started'] == true && e['completed'] == true))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Assigned Task"),
          bottom: TabBar(
            tabs: [
              Text("Not Started"),
              Text("Pending"),
              Text("Completed"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: notStarted!.length,
              itemBuilder: (context, index) {
                return TaskTypeTile(
                  data: notStarted![index],
                  refresh: () {},
                  enable: false,
                );
              },
            ),
            ListView.builder(
              itemCount: pending!.length,
              itemBuilder: (context, index) {
                return TaskTypeTile(
                  data: pending![index],
                  refresh: () {},
                  enable: false,
                );
              },
            ),
            ListView.builder(
              itemCount: completed!.length,
              itemBuilder: (context, index) {
                return TaskTypeTile(
                  data: completed![index],
                  refresh: () {},
                  enable: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
