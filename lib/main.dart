import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walltex_app/Providers/control_provider.dart';
import 'package:walltex_app/Screens/add_user_screen.dart';
import 'package:walltex_app/Screens/dashboard_screen.dart';
import 'package:walltex_app/Screens/lead_entry_screen.dart';
import 'package:walltex_app/Screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ControlProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Walltex CRP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
