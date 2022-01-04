import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walltex_app/Helpers/date_format_from_data_base.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Providers/control_provider.dart';
import 'package:walltex_app/Screens/dashboard_screen.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/control.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String reActivationNumber1 = "9373103689";
  final String reActivationNumber2 = "7276092220";
  Input username = Input(label: "Username");

  Input password = Input.password(label: "Password");

  bool loading = false;

  bool validity = true;

  void setValidity(bool val) {
    print(val);
    setState(() {
      validity = val;
    });
  }

  handleLogin() async {
    setState(() {
      loading = true;
    });
    if (username.value().isNotEmpty && password.value().isNotEmpty) {
      var res = await User.login(
        username: username.value(),
        password: password.value(),
      );

      if (res['value'] == true) {
        User user = res['data'];

        if (user.isBlocked() == false) {
          Provider.of<ControlProvider>(context, listen: false)
              .setUser(user: user);
          showSnakeBar(context, res['msg']);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Dashboard(),
            ),
          );
        } else if (user.isBlocked() == true) {
          showSnakeBar(context, "You Are Been Blocked From Using This App");
        }
      } else {
        showSnakeBar(context, "No User Found");
      }
    } else {
      showSnakeBar(context, "Please Fill All Fields");
    }
    setState(() {
      loading = false;
    });
  }

  dynamic companyData;

  bool checkValidity(DateTime inputDate) {
    if (inputDate.difference(DateTime.now()).inDays <= 0) {
      return false;
    } else
      // widget.validyCheckCallback!(true); // product not expired
      return true;
  }

  int daysRemaining(DateTime inputDate) {
    int days = inputDate.difference(DateTime.now()).inDays;
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
              child: FutureBuilder(
                future: Query.execute(query: "select * from co"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loader.circular;
                  }
                  List<dynamic> data = snapshot.data as List<dynamic>;

                  if (data.isEmpty || data[0]['expdate'] == null) {
                    return Center(
                      child: Column(
                        children: [
                          Text(
                            "Error Occured While Getting Company Information\nCheck! Have you entered correct company Id ?",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text("Entered Id Refer to ${data[0]['Name']}",
                              style: Control.onlybold),
                        ],
                      ),
                    );
                  }

                  companyData = data[0];

                  bool _isProductOpen = checkValidity(
                      onlyDateFromDataBase(companyData['expdate']));

                  // for testing
                  // bool _isProductOpen = checkValidity(DateTime(1900));

                  if (_isProductOpen == false) {
                    return Column(
                      children: [
                        Chip(label: Text("Product Expired")),
                        ListTile(
                          title: Text(
                            "Please Contact\n$reActivationNumber1 or $reActivationNumber2\nfor Product Reactivation",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            launch("tel://$reActivationNumber1");
                          },
                          icon: Icon(
                            Icons.call,
                          ),
                          label: Text("Cal $reActivationNumber1"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            launch("tel://$reActivationNumber2");
                          },
                          icon: Icon(
                            Icons.call,
                          ),
                          label: Text("Call $reActivationNumber2"),
                        )
                      ],
                    );
                  } else if (_isProductOpen == true) {
                    return Column(
                      children: [
                        // name
                        Text(
                          companyData['Name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            (companyData['expdate'] != null ||
                                    companyData['expdate'] != '' ||
                                    onlyDateFromDataBase(
                                            companyData['expdate']) !=
                                        DateTime(1900))
                                // expiry info
                                ? Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          "Product will expire on \n${dateFormatFromDataBase(companyData['expdate'])}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "You Have ${daysRemaining(onlyDateFromDataBase(companyData['expdate']))} Days Remaining",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 0,
                                  ),
                            username.builder(),
                            password.builder(),
                            loading == true
                                ? Loader.circular
                                : ElevatedButton(
                                    onPressed: handleLogin,
                                    child: const Text("Login"),
                                  ),
                          ],
                        )
                      ],
                    );
                  } else {
                    return Chip(label: Text("Unable To Connect To Server"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
