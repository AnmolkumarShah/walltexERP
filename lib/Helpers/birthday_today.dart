import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/phone_call.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/whatsApp.dart';
import 'package:walltex_app/Screens/birthday_screen.dart';
import 'package:walltex_app/control.dart';

import 'date_format_from_data_base.dart';

class BirthDayToday extends StatelessWidget {
  const BirthDayToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Query.execute(query: "select id,Name,dob,anniv,Mobile from leads"),
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.data == null) {
          return Container(
            height: 20,
            width: double.infinity,
            color: Colors.black,
            child: Text(
              "Error In Getting Events",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          );
        }
        List<dynamic> data = snapshot.data as List<dynamic>;
        List<Map<String, dynamic>> combine = [];
        data.forEach((e) {
          if (onlyDateFromValue(e['dob']) == onlyDateNow()) {
            combine.add(
                {"Type": "Birthday", "Name": e['Name'], "Number": e['Mobile']});
          }
          if (onlyDateFromValue(e['anniv']) == onlyDateNow()) {
            combine.add({
              "Type": "Anniversary",
              "Name": e['Name'],
              "Number": e['Mobile']
            });
          }
        });
        if (combine.isEmpty) {
          return Container(
            height: 20,
            width: double.infinity,
            color: Colors.black,
            child: Text(
              "There are No Events",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          );
        }
        return Row(
          children: [
            Container(
              width: 30,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        "Today's Event",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: EventSlider(list: combine)),
            RotatedBox(
                quarterTurns: 3,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BirthdayScreen()));
                    },
                    child: const Text("View All")))
          ],
        );
      },
    );
  }
}

class EventSlider extends StatelessWidget {
  EventSlider({Key? key, required this.list}) : super(key: key);
  List<dynamic> list;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: list.map((e) => Tile(data: e)).toList(),
        options: CarouselOptions(
          height: 92,
          initialPage: 0,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: false,
          autoPlayInterval: Duration(seconds: 10),
          autoPlayAnimationDuration: Duration(milliseconds: 1000),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: false,
          scrollDirection: Axis.horizontal,
        ));
  }
}

class Tile extends StatelessWidget {
  Tile({Key? key, this.data}) : super(key: key);
  dynamic data;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(data['Name'], style: Control.eventStyle),
        subtitle: Text(data['Type'], style: Control.onlybold),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WhatsAppContact(number: data['Number'], onlyIcon: true),
            PhoneCall(number: data['Number'], onlyIcon: true)
          ],
        ),
      ),
      elevation: 8,
      shadowColor: Colors.green,
      margin: EdgeInsets.all(10),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white)),
    );
  }
}
