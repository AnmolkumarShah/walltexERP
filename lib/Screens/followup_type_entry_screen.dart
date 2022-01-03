import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Services/followup_type.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/control.dart';

class FollowupTypeEntry extends StatefulWidget {
  const FollowupTypeEntry({Key? key}) : super(key: key);

  @override
  State<FollowupTypeEntry> createState() => _FollowupTypeEntryState();
}

class _FollowupTypeEntryState extends State<FollowupTypeEntry> {
  final Input _followupType = Input(label: "Followup Type Name");
  bool loading = false;

  handleSave() async {
    setState(() {
      loading = true;
    });

    if (!_followupType.isEmpty()) {
      FollowupType prod = FollowupType(desc: _followupType.value(), id: -1);
      dynamic res = await prod.save();
      if (res == true) {
        showSnakeBar(context, "Type Saved Successfully");
        Navigator.pop(context);
      } else {
        showSnakeBar(context, "Error In Type Saving");
      }
    } else {
      showSnakeBar(context, "Enter Type Name");
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Control.followupTypeScreen['name'].toString()),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: FutureBuilder(
                future: Query.fetch(FollowupType()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loader.circular;
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: const Text("Error Occure"),
                    );
                  }
                  List<FollowupType> data = snapshot.data as List<FollowupType>;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(
                          data[index].show(),
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
                  _followupType.builder(),
                  TextButton(
                    onPressed: handleSave,
                    child: const Text("Save Followup Type"),
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
