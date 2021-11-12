import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Services/user_class.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Input username = Input(label: "Username");

  Input password = Input.password(label: "Password");

  handleLogin() async {
    if (username.value().isNotEmpty && password.value().isNotEmpty) {
      var res = await User.login(
          username: username.value(), password: password.value());
      if (res['value'] == true) {
        print(res);
        showSnakeBar(context, res['msg']);
      }
    } else {
      showSnakeBar(context, "Please Fill All Fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 60,
                  spreadRadius: 10,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                username.builder(),
                password.builder(),
                ElevatedButton(
                  onPressed: handleLogin,
                  child: const Text("Login"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
