import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/task_class.dart';
import 'package:walltex_app/control.dart';

class TaskEntryScreen extends StatefulWidget {
  const TaskEntryScreen({Key? key}) : super(key: key);

  @override
  State<TaskEntryScreen> createState() => _FollowupTypeEntryState();
}

class _FollowupTypeEntryState extends State<TaskEntryScreen> {
  final Input _taskName = Input(label: "Type Name");
  final Input _taskDays = Input.number(label: "Days");
  bool loading = false;

  handleSave() async {
    setState(() {
      loading = true;
    });

    if (!_taskName.isEmpty() && _taskDays.valueInt() > 0) {
      TaskType prod =
          TaskType(d: _taskDays.valueInt(), type: _taskName.value());
      dynamic res = await prod.save();
      if (res == true) {
        showSnakeBar(context, "TaskType Saved Successfully");
        Navigator.pop(context);
      } else {
        showSnakeBar(context, "Error In TaskType Saving");
      }
    } else if (_taskDays.valueInt() <= 0) {
      showSnakeBar(context, "Assigned Days Cannot Be Zero Or Less");
    } else {
      showSnakeBar(context, "Enter Both Task Name And Days");
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Control.taskTypeScreen['name'].toString()),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: FutureBuilder(
                future: Query.fetch(TaskType()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loader.circular;
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: const Text("Error Occure"),
                    );
                  }
                  List<TaskType> data = snapshot.data as List<TaskType>;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(
                          data[index].show(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          data[index].days.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _taskName.builder(),
                  _taskDays.builder(),
                  TextButton(
                    onPressed: handleSave,
                    child: const Text("Save TaskType"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
