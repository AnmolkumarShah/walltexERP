import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/references_class.dart';
import 'package:walltex_app/control.dart';

class ReferenceEntryScreen extends StatefulWidget {
  const ReferenceEntryScreen({Key? key}) : super(key: key);

  @override
  State<ReferenceEntryScreen> createState() => _ReferenceEntryScreenState();
}

class _ReferenceEntryScreenState extends State<ReferenceEntryScreen> {
  final Input _reference = Input(label: "Refferance Name");
  bool loading = false;

  handleSave() async {
    setState(() {
      loading = true;
    });

    if (!_reference.isEmpty()) {
      References refer = References(desc: _reference.value(), id: -1);
      dynamic res = await refer.save();
      if (res == true) {
        showSnakeBar(context, "Refferance Saved Successfully");
        Navigator.pop(context);
      } else {
        showSnakeBar(context, "Error In Product Saving");
      }
    } else {
      showSnakeBar(context, "Enter Refferance Name");
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Control.referenceScreen['name'].toString()),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: FutureBuilder(
                future: Query.fetch(References()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loader.circular;
                  }
                  List<References> data = snapshot.data as List<References>;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(
                          data[index].display(),
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
                  _reference.builder(),
                  TextButton(
                    onPressed: handleSave,
                    child: const Text("Save Refferance"),
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
