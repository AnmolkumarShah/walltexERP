import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/salesman_class.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/control.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  bool loading = false;

  final Input _name = Input(label: "Username");
  final Input _password = Input(label: "Password");

  Future save() async {
    if (_name.value() == '' || _password.value() == "") {
      showSnakeBar(context, "Enter Name And Password");
      return;
    }
    setState(() {
      loading = true;
    });

    User? user = User(
      nm: _name.value(),
      pwd: _password.value(),
    );

    dynamic res = await user.save();
    if (res['value'] == true) {
      showSnakeBar(context, res['msg']);
    } else {
      showSnakeBar(context, res['msg']);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Control.addUserScreen['name'].toString()),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Chip(
            label: Text(
              "Swipe Down To Refresh",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: User.allUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loader.circular;
                  }
                  var data = snapshot.data as List<dynamic>;
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return (data[index] as User).display(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _name.builder(),
                    _password.builder(),
                    loading == false
                        ? TextButton(
                            onPressed: save,
                            child: const Text("Add User"),
                          )
                        : Loader.circular,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class NormalUserTile extends StatelessWidget {
  Salesman? user;
  NormalUserTile({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text("user!.usrname!"),
    );
  }
}
