import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/phone_call.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/whatsApp.dart';
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
        if (snapshot.hasError) {
          return Chip(label: const Text("Error in getting today birthday"));
        }
        List<dynamic> data = snapshot.data as List<dynamic>;
        List<Map<String, dynamic>> combine = [];
        // print(data);
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
    return Control.myEnvolop(
      Colors.pink[100],
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(data['Name'], style: Control.eventStyle),
              Text(data['Type'], style: Control.onlybold),
            ],
          ),
          Row(
            children: [
              WhatsAppContact(number: data['Number']),
              PhoneCall(number: data['Number'])
            ],
          ),
        ],
      ),
    );
  }
}
