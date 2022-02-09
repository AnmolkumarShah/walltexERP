import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Providers/control_provider.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/Widgets/task_type_tile.dart';

import 'new_task_type.dart';

class AllTaskScreen extends StatefulWidget {
  const AllTaskScreen({Key? key, required this.leadId}) : super(key: key);
  final int leadId;

  @override
  State<AllTaskScreen> createState() => _AllTaskScreenState();
}

class _AllTaskScreenState extends State<AllTaskScreen> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User _currUser =
        Provider.of<ControlProvider>(context, listen: false).getUser();

    return Scaffold(
      appBar: AppBar(title: const Text("All Task")),
      body: FutureBuilder(
        future: Query.execute(query: """
            select  t.taskid, t.tasktype,t.leadid,t.seqno, t.allotdt,t.started,
            t.complby,t.completed,t.complon,t.rem,
            (select Name from leads where id = t.leadid ) as leadname,
            (select Mobile from leads where id = t.leadid ) as leadnumber,
            (select mobile from usr_mast where id = (select sman from leads where id = t.leadid) ) as allotedByNumber,
            (select usr_nm from usr_mast where id = t.allotto)  as allotedto,
            (select task from tasktype where tasktype = t.tasktype) as task from tasks t 
            where t.leadid  = ${widget.leadId}
            order by t.seqno
            """),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader.circular;
          }
          List<dynamic> data = snapshot.data as List<dynamic>;
          if (data.isEmpty) {
            return const Center(
              child: Chip(label: Text("No Task Found")),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return TaskTypeTile(
                data: data[index],
                refresh: refresh,
                enable: true,
              );
            },
          );
        },
      ),
      floatingActionButton: (_currUser.isAdmin() == true)
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewTaskType(
                      leadId: widget.leadId,
                      enable: true,
                    ),
                  ),
                );
                refresh();
              },
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [const Icon(Icons.add), const Text("Add Task")],
              ),
            )
          : const SizedBox(height: 0),
    );
  }
}
