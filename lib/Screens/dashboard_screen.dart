import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walltex_app/Providers/control_provider.dart';
import 'package:walltex_app/Services/user_class.dart';
import 'package:walltex_app/Widgets/OptionTile.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    User? currentUser =
        Provider.of<ControlProvider>(context, listen: false).getUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: currentUser.availableOption().length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final val = currentUser.availableOption();
            return OptionTile(
              title: val[index]['name'],
              next: val[index]['value'],
            );
          },
        ),
      ),
    );
  }
}
